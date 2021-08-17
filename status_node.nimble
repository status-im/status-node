# Package

version       = "0.1.0"
author        = "Status Research & Development GmbH"
description   = "Status Node"
license       = "MPL2"
srcDir        = "src"
bin           = @["status_node"]
skipExt       = @["nim"]

# Deps

requires "nim >= 1.0.0", " nimqml >= 0.7.0", "stint", "nimcrypto >= 0.4.11", "uuids >= 0.1.10"
