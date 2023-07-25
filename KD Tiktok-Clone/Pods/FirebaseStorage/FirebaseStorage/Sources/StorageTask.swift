// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

#if COCOAPODS
  import GTMSessionFetcher
#else
  import GTMSessionFetcherCore
#endif

/**
 * A superclass to all Storage tasks, including `StorageUploadTask`
 * and `StorageDownloadTask`, to provide state transitions, event raising, and common storage
 * for metadata and errors.
 * Callbacks are always fired on the developer-specified callback queue.
 * If no queue is specified, it defaults to the main queue.
 * This class is not thread safe, so only call methods on the main thread.
 */
@objc(FIRStorageTask) open class StorageTask: NSObject {
  /**
   * An immutable view of the task and associated metadata, progress, error, etc.
   */
  @objc public var snapshot: StorageTaskSnapshot {
    objc_sync_enter(StorageTask.self)
    defer { objc_sync_exit(StorageTask.self) }
    let progress = Progress(totalUnitCount: self.progress.totalUnitCount)
    progress.completedUnitCount = self.progress.completedUnitCount
    return StorageTaskSnapshot(
      task: self,
      state: state,
      reference: reference,
      progress: progress,
      metadata: metadata,
      error: error
    )
  }

  // MARK: - Internal Implementations

  /**
   * State for the current task in progress.
   */
  internal var state: StorageTaskState

  /**
   * StorageMetadata for the task in progress, or nil if none present.
   */
  internal var metadata: StorageMetadata?

  /**
   * Error which occurred during task execution, or nil if no error occurred.
   */
  internal var error: NSError?

  /**
   * NSProgress object which tracks the progress of an observable task.
   */
  internal var progress: Progress

  /**
   * Reference pointing to the location the task is being performed against.
   */
  internal let reference: StorageReference

  /**
   * A serial queue for all storage operations.
   */
  internal let dispatchQueue: DispatchQueue

  internal let fetcherService: GTMSessionFetcherService

  internal let baseRequest: URLRequest

  internal init(reference: StorageReference,
                service: GTMSessionFetcherService,
                queue: DispatchQueue) {
    self.reference = reference
    fetcherService = service
    fetcherService.maxRetryInterval = reference.storage.maxOperationRetryInterval
    dispatchQueue = queue
    state = .unknown
    progress = Progress(totalUnitCount: 0)
    baseRequest = StorageUtils.defaultRequestForReference(reference: reference)
  }
}

/**
 * Defines task operations such as pause, resume, cancel, and enqueue for all tasks.
 * All tasks are required to implement enqueue, which begins the task, and may optionally
 * implement pause, resume, and cancel, which operate on the task to pause, resume, and cancel
 * operations.
 */
@objc(FIRStorageTaskManagement) public protocol StorageTaskManagement: NSObjectProtocol {
  /**
   * Prepares a task and begins execution.
   */
  @objc func enqueue() -> Void

  /**
   * Pauses a task currently in progress.
   */
  @objc optional func pause() -> Void

  /**
   * Cancels a task.
   */
  @objc optional func cancel() -> Void

  /**
   * Resumes a paused task.
   */
  @objc optional func resume() -> Void
}
