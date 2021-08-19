import node, settings
import libstatus/settings as libstatus_settings
import ../eventemitter
import ./tasks/task_runner_impl

export node, task_runner_impl, eventemitter

type Status* = ref object
  events*: EventEmitter
  node*: NodeModel
  tasks*: TaskRunner
  settings*: SettingsModel

proc newStatusInstance*(): Status =
  result = Status()
  result.tasks = newTaskRunner()
  result.events = createEventEmitter()
  result.settings = settings.newSettingsModel(result.events)
  result.node = node.newNodeModel()
  
proc initNode*(self: Status) =
  self.tasks.init()
  self.settings.initNode()

proc reset*(self: Status) =
  discard

proc getNodeVersion*(self: Status): string =
  libstatus_settings.getWeb3ClientVersion()
