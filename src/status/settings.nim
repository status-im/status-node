import json, json_serialization

import 
  sugar, sequtils, strutils, atomics

import libstatus/settings as libstatus_settings
import ../eventemitter
import signals/types

#TODO: temporary?
import types as LibStatusTypes

type
    SettingsModel* = ref object
        events*: EventEmitter

proc newSettingsModel*(events: EventEmitter): SettingsModel =
  result = SettingsModel()
  result.events = events

proc startNode*(self: SettingsModel, jsonConfig: string) =
  libstatus_settings.startNode(jsonConfig)

proc stopNode*(self: SettingsModel) =
  libstatus_settings.stopNode()