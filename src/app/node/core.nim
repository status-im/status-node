import NimQml, chronicles
import ../../status/signals/types
import ../../status/[status, node]
import ../../status/types as status_types
import ../../eventemitter
import view

logScope:
  topics = "node"

type NodeController* = ref object
  status*: Status
  view*: NodeView
  variant*: QVariant

proc newController*(status: Status, fleetConfig: string): NodeController =
  result = NodeController()
  result.status = status
  result.view = newNodeView(status, fleetConfig)
  result.variant = newQVariant(result.view)

proc delete*(self: NodeController) =
  delete self.variant
  delete self.view

proc init*(self: NodeController) =
  self.status.events.on(SignalType.Stats.event) do (e:Args):
    self.view.setStats(StatsSignal(e).stats)

  self.status.events.on(SignalType.NodeStarted.event) do (e:Args):
    self.view.setNodeActive(true)

  self.status.events.on(SignalType.NodeCrashed.event) do (e:Args):
    self.view.setNodeActive(false)

  self.status.events.on(SignalType.NodeStopped.event) do (e:Args):
    self.view.setNodeActive(false)