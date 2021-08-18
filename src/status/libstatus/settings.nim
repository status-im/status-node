import
  json, tables, sugar, sequtils, strutils, atomics, os

import
  json_serialization, chronicles, uuids

import
  ./core, ../types, ../signals/types as statusgo_types, ./accounts/constants,
  ../utils

from status_go import nil

proc getWeb3ClientVersion*(): string =
  parseJson(callPrivateRPC("web3_clientVersion"))["result"].getStr

proc startNode*(jsonConfig: string) =
  echo status_go.startDesktopNode(jsonConfig)
  # TODO: error handling

proc stopNode*() =
  echo status_go.logout()
  # TODO: error handling
