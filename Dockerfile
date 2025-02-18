# Copyright the Velero contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM --platform=$BUILDPLATFORM golang:1.17-stretch as build
ARG TARGETOS
ARG TARGETARCH

COPY . .
RUN GOPATH= GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o velero-plugin-for-csi .

FROM busybox:1.34.1-uclibc AS busybox

FROM scratch

COPY --from=busybox /bin/cp /bin/cp
COPY --from=build /go/velero-plugin-for-csi /plugins/

USER 65532:65532
ENTRYPOINT ["cp", "/plugins/velero-plugin-for-csi", "/target/."]
