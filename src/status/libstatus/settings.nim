import
  json, tables, sugar, sequtils, strutils, atomics, os

from status_go import multiAccountGenerateAndDeriveAddresses, generateAlias, identicon, saveAccountAndLogin, login, openAccounts, getNodeConfig

import
  json_serialization, chronicles, uuids

import
  ./core, ../types, ../signals/types as statusgo_types, ./constants,
  ../utils

from status_go import nil

proc initNode*() =
  createDir(STATUSGODIR)
  createDir(KEYSTOREDIR)
  discard $status_go.initKeystore(KEYSTOREDIR)

proc getWeb3ClientVersion*(): string =
  parseJson(callPrivateRPC("web3_clientVersion"))["result"].getStr

proc startNode*(jsonConfig: string) =
  echo status_go.startDesktopNode(jsonConfig)
  # TODO: error handling

proc stopNode*() =
  echo status_go.logout()
  # TODO: error handling
