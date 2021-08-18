import NimQml, chronicles
import ../../status/[status, node, settings]
import ../../status/signals/types as signal_types
import ../../status/libstatus/accounts/constants

logScope:
  topics = "node-view"

QtObject:
  type NodeView* = ref object of QObject
    status*: Status
    stats*: Stats
    fleetConfig: string
    nodeActive*: bool

  proc setup(self: NodeView) =
    self.QObject.setup

  proc newNodeView*(status: Status, fleetConfig: string): NodeView =
    new(result)
    result.status = status
    result.nodeActive = false
    result.fleetConfig = fleetConfig
    result.setup

  proc delete*(self: NodeView) =
    self.QObject.delete

  proc getDataDir(self:NodeView): string {.slot.} = DATADIR

  QtProperty[string] dataDir:
    read = getDataDir

  proc getNodeActive(self:NodeView): bool {.slot.} = self.nodeActive

  proc nodeActiveChanged(self:NodeView, value:bool) {.signal.}

  proc setNodeActive*(self:NodeView, value: bool) {.slot.} =
    self.nodeActive = value
    self.nodeActiveChanged(value)

  QtProperty[bool] nodeActive:
    read = getNodeActive
    notify = nodeActiveChanged

  proc getFleetConfig(self:NodeView): string {.slot.} = self.fleetConfig

  QtProperty[string] fleetConfig:
    read = getFleetConfig

  proc statsChanged*(self: NodeView) {.signal.}

  proc setStats*(self: NodeView, stats: Stats) =
    self.stats = stats
    self.statsChanged()

  proc resetStats(self: NodeView) =
    self.setStats(Stats())

  proc uploadRate*(self: NodeView): string {.slot.} = $self.stats.uploadRate

  QtProperty[string] uploadRate:
    read = uploadRate
    notify = statsChanged

  proc downloadRate*(self: NodeView): string {.slot.} = $self.stats.downloadRate

  QtProperty[string] downloadRate:
    read = downloadRate
    notify = statsChanged

  proc startNode*(self: NodeView, jsonConfig: string) {.slot.} =
    self.status.settings.startNode(jsonConfig)

  proc stopNode*(self: NodeView) {.slot.} =
    self.status.settings.stopNode()
    self.setNodeActive(false)
    self.resetStats()
