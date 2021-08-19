import NimQml, chronicles, eth/[keys, p2p], os, json, httpclient
import ../../status/[status, node, settings]
import ../../status/signals/types as signal_types
import ../../status/libstatus/constants

logScope:
  topics = "node-view"

QtObject:
  type NodeView* = ref object of QObject
    status*: Status
    stats*: Stats
    fleetConfig: string
    ipAddress: string
    publicKey: string
    privateKey: string
    nodeActive*: bool

  proc setup(self: NodeView) =
    var client = newHttpClient()
    self.ipAddress = client.getContent("https://ipecho.net/plain")

    let keyFilename = KEYSTOREDIR / "nodekey"
    if(not fileExists(keyFilename)):
      let signKeyPair = KeyPair.random(keys.newRng()[])
      self.privateKey = $signKeyPair.seckey
      writeFile(keyFilename, self.privateKey)
      setFilePermissions(keyFilename, {FilePermission.fpUserRead})
      self.publicKey = $signKeyPair.pubkey
    else:
      self.privateKey = readFile(keyFilename)
      self.publicKey = $PrivateKey.fromHex(self.privateKey).get.toPublicKey()

    self.QObject.setup

  proc newNodeView*(status: Status, fleetConfig: string): NodeView =
    new(result)
    result.status = status
    result.nodeActive = false
    result.ipAddress = "0.0.0.0"
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
    let config = jsonConfig.parseJson
    config["nodeKey"] = newJString(self.privateKey)
    self.status.settings.startNode($config)

  proc stopNode*(self: NodeView) {.slot.} =
    self.status.settings.stopNode()
    self.setNodeActive(false)
    self.resetStats()

  proc copyToClipboard*(self: NodeView, content: string) {.slot.} =
    setClipBoardText(content)

  proc getPublicKey*(self: NodeView): string {.slot.} = self.publicKey

  QtProperty[string] publicKey:
    read = getPublicKey

  proc getIpAddress*(self: NodeView): string {.slot.} = self.ipAddress

  QtProperty[string] ipAddress:
    read = getIpAddress

  const DESKTOP_VERSION {.strdefine.} = "0.0.0"

  proc getCurrentVersion*(self: NodeView): string {.slot.} =
    return DESKTOP_VERSION

  QtProperty[string] currentVersion:
    read = getCurrentVersion