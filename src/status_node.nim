import NimQml, chronicles, os, strformat

#import app/node/core as node
#import app/utilsView/core as utilsView
#import status/signals/core as signals
#import status/types
#import status/constants
import status_go
#import status/status as statuslib
import ./eventemitter

var signalsQObjPointer: pointer

logScope:
  topics = "main"

proc mainProc() =
  if defined(macosx) and defined(production):
    setCurrentDir(getAppDir())

  var currentLanguageCode: string

  let fleets =
    if defined(windows) and defined(production):
      "/../resources/fleets.json"
    else:
      "/../fleets.json"

  let
    fleetConfig = readFile(joinPath(getAppDir(), fleets))
   # status = statuslib.newStatusInstance(fleetConfig)
    
  #status.initNode()

  enableHDPI()
  initializeOpenGL()

  let app = newQGuiApplication()
  defer: app.delete()

  let resources =
    if defined(windows) and defined(production):
      "/../resources/resources.rcc"
    else:
      "/../resources.rcc"
  QResource.registerResource(app.applicationDirPath & resources)

  let statusAppIcon =
    if defined(production):
      if defined(macosx):
        "" # not used in macOS
      elif defined(windows):
        "/../resources/status.svg"
      else:
        "/../status.svg"
    else:
      if defined(macosx):
        "" # not used in macOS
      else:
        "/../status-dev.svg"

  if not defined(macosx):
    app.icon(app.applicationDirPath & statusAppIcon)

  var i18nPath = ""
  if defined(development):
    i18nPath = joinPath(getAppDir(), "../ui/i18n")
  elif (defined(windows)):
    i18nPath = joinPath(getAppDir(), "../resources/i18n")
  elif (defined(macosx)):
    i18nPath = joinPath(getAppDir(), "../i18n")
  elif (defined(linux)):
    i18nPath = joinPath(getAppDir(), "../i18n")


  let engine = newQQmlApplicationEngine()
  defer: engine.delete()
  engine.addImportPath("qrc:/./StatusQ/src")
  
  # Register events objects
  let dockShowAppEvent = newStatusDockShowAppEventObject(engine)
  defer: dockShowAppEvent.delete()
  let osThemeEvent = newStatusOSThemeEventObject(engine)
  defer: osThemeEvent.delete()
  app.installEventFilter(dockShowAppEvent)
  app.installEventFilter(osThemeEvent)

 # let signalController = signals.newController(status)
  #defer:
   # signalsQObjPointer = nil
    #signalController.delete()

  # We need this global variable in order to be able to access the application
  # from the non-closure callback passed to `libstatus.setSignalEventCallback`
  #signalsQObjPointer = cast[pointer](signalController.vptr)

 
 # var node = node.newController(status, netAccMgr)
  #defer: node.delete()
  #engine.setRootContextProperty("nodeModel", node.variant)

  #var utilsController = utilsView.newController(status)
  #defer: utilsController.delete()
  #engine.setRootContextProperty("utilsModel", utilsController.variant)

  proc changeLanguage(locale: string) =
    if (locale == currentLanguageCode):
      return
    currentLanguageCode = locale
    let shouldRetranslate = not defined(linux)
    engine.setTranslationPackage(joinPath(i18nPath, fmt"qml_{locale}.qm"), shouldRetranslate)



  #  status.tasks.marathon.onLoggedIn()



  # this should be the last defer in the scope
  defer:
    info "Status app is shutting down..."
    #status.tasks.teardown()


  #initControllers()

  # Handle node.stopped signal when user has logged out
#  status.events.once("nodeStopped") do(a: Args):
    # TODO: remove this once accounts are not tracked in the AccountsModel
 #   status.reset()

    # 2. Re-init controllers that don't require a running node
  #  initControllers()

#  engine.setRootContextProperty("signals", signalController.variant)
 
  var prValue = newQVariant(if defined(production): true else: false)
  engine.setRootContextProperty("production", prValue)

  # We're applying default language before we load qml. Also we're aware that 
  # switch language at runtime will have some impact to cpu usage.
  # https://doc.qt.io/archives/qtjambi-4.5.2_01/com/trolltech/qt/qtjambi-linguist-programmers.html
  changeLanguage("en")

  engine.load(newQUrl("qrc:///main.qml"))

  # Please note that this must use the `cdecl` calling convention because
  # it will be passed as a regular C function to libstatus. This means that
  # we cannot capture any local variables here (we must rely on globals)
  var callback: SignalCallback = proc(p0: cstring) {.cdecl.} =
    discard
   # if signalsQObjPointer != nil:
      #signal_handler(signalsQObjPointer, p0, "receiveSignal")

  status_go.setSignalEventCallback(callback)

  # Qt main event loop is entered here
  # The termination of the loop will be performed when exit() or quit() is called
  info "Starting application..."
  app.exec()

when isMainModule:
  mainProc()
