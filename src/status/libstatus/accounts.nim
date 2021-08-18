import json, os, uuids, json_serialization, chronicles, strutils

from status_go import multiAccountGenerateAndDeriveAddresses, generateAlias, identicon, saveAccountAndLogin, login, openAccounts, getNodeConfig
import core
import ../utils as utils
import ../types as types
import accounts/constants
import ../signals/types as signal_types

proc initNode*() =
  createDir(STATUSGODIR)
  createDir(KEYSTOREDIR)
  discard $status_go.initKeystore(KEYSTOREDIR)
