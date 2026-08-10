///|
priv enum ChildExit {
  Exited(Int)
  CancelledForStop
}

///|
/// Construct the native local-process backend.
///
/// The backend writes stdin, streams stdout one line at a time, captures stderr,
/// reports the exit status, and guarantees child cleanup on stop, cancellation,
/// or callback failure.
pub fn backend() -> @cli.ProcessBackend {
  @cli.ProcessBackend::new(execute_native)
}

///|
async fn execute_native(
  invocation : @cli.Invocation,
  on_line : async (String) -> Bool,
) -> @cli.RunResult {
  let stop_requested = Ref(false)
  @async.with_task_group(async fn(group) {
    let (child_input, input_writer) = @process.write_to_process()
    let (output_reader, child_output) = @process.read_from_process()
    let (error_reader, child_error) = @process.read_from_process()
    group.spawn_bg(async fn() {
      defer input_writer.close()
      input_writer.write(invocation.input)
    })
    let stderr_task = group.spawn(async fn() {
      defer error_reader.close()
      error_reader.read_all().text()
    })
    let child = @process.spawn(
      group,
      invocation.command,
      invocation.arguments,
      extra_env=invocation.environment,
      inherit_env=invocation.inherit_environment,
      stdin=child_input,
      stdout=child_output,
      stderr=child_error,
      cancel_handler=@process.hard_cancel(),
    )
    let stdout_task = group.spawn(async fn() {
      defer output_reader.close()
      while output_reader.read_until("\n") is Some(line) {
        if !on_line(line) {
          stop_requested.val = true
          child.cancel()
          break
        }
      }
    })
    let child_exit = try {
      let code = child.wait()
      if stop_requested.val {
        CancelledForStop
      } else {
        Exited(code)
      }
    } catch {
      error if stop_requested.val && @async.is_cancellation_error(error) =>
        CancelledForStop
      error => raise error
    }
    let exited_with_failure = match child_exit {
      Exited(code) => code != 0
      CancelledForStop => false
    }
    if exited_with_failure {
      stdout_task.cancel()
      stdout_task.wait() catch {
        error => if !@async.is_cancellation_error(error) { raise error }
      }
    } else {
      stdout_task.wait()
    }
    let stderr = if stop_requested.val {
      stderr_task.cancel()
      try stderr_task.wait() |> ignore catch {
        error => if !@async.is_cancellation_error(error) { raise error }
      }
      ""
    } else {
      stderr_task.wait()
    }
    match child_exit {
      Exited(0) => @cli.RunResult::Completed
      Exited(code) => @cli.RunResult::Failed(code~, stderr~)
      CancelledForStop => @cli.RunResult::Stopped
    }
  })
}
