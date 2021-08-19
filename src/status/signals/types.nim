import json_serialization
import ../types
import ../../eventemitter

type Signal* = ref object of Args
  signalType* {.serializedFieldName("type").}: SignalType

type StatusGoError* = object
  error*: string

type NodeSignal* = ref object of Signal
  event*: StatusGoError

type Stats* = object
  uploadRate*: uint64
  downloadRate*: uint64

type StatsSignal* = ref object of Signal
  stats*: Stats

type DiscoverySummarySignal* = ref object of Signal
  enodes*: seq[string]