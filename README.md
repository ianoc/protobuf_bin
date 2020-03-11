# protobuf bin


## Motivation
Where i work/others end up with a lot of pain with bazel on os x compiling protobuf. XCode requirements, leaking sandboxes and even binaries produced that segfault a new fun pain.


## Goal
Given a sha configured in the repo:

1. Pull down the github protobuf repo
2. Compile for linux + macos binaries of protoc
3. Re-write the root BUILD file in the protobuf repo to use an external repo/download the protoc binaries instead of building them. Could probably use a select if being fancy to fall back to building it.
4. Have github actions make a release with:
   a) Linux binary
   b) Mac Binary
   c) Zip containing the modified protobuf repo
   e) Snippet showing how to slot this repo in instead of the usual protobuf repo.
   d) Sha256's of all of the above
