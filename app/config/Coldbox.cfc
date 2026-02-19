component {

    function configure(){

        variables.coldbox = {
            appName                  : getSystemSetting( "APPNAME", "InterviewPrep" ),
            eventName                : "event",
            reinitPassword           : "",
            reinitKey                : "fwreinit",
            handlersIndexAutoReload  : true,
            defaultEvent             : "main.index",
            requestStartHandler      : "Main.onRequestStart",
            requestEndHandler        : "",
            applicationStartHandler  : "Main.onAppInit",
            applicationEndHandler    : "",
            sessionStartHandler      : "",
            sessionEndHandler        : "",
            missingTemplateHandler   : "",
            applicationHelper        : "/app/helpers/ApplicationHelper.cfm",
            viewsHelper              : "",
            modulesExternalLocation  : [ "/modules" ],
            viewsExternalLocation    : "",
            layoutsExternalLocation  : "",
            handlersExternalLocation : "",
            requestContextDecorator  : "",
            controllerDecorator      : "",
            invalidHTTPMethodHandler : "",
            exceptionHandler         : "main.onException",
            invalidEventHandler      : "",
            customErrorTemplate      : "",
            handlerCaching           : false,
            eventCaching             : false,
            viewCaching              : false,
            autoMapModels            : true,
            jsonPayloadToRC          : true
        };

        variables.settings = {
            appTitle : "InterviewPrep",
            appDescription : "Interview Preparation & MCQ Test Platform"
        };

        variables.modules = {
            include : [],
            exclude : []
        };

        variables.logBox = {
            appenders : {
                consolelog : { class : "coldbox.system.logging.appenders.ConsoleAppender" },
                filelog    : {
                    class      : "coldbox.system.logging.appenders.RollingFileAppender",
                    properties : { filename : "app", filePath : "/app/logs" }
                }
            },
            root : { levelmax : "INFO", appenders : "*" },
            info : [ "coldbox.system" ]
        };

        variables.layoutSettings = { defaultLayout : "Main", defaultView : "" };

        variables.interceptorSettings = { customInterceptionPoints : [] };

        variables.interceptors = [
            { class : "app.interceptors.AuthInterceptor" }
        ];

        variables.moduleSettings = {};

        variables.flash = {
            scope        : "session",
            properties   : {},
            inflateToRC  : true,
            inflateToPRC : false,
            autoPurge    : true,
            autoSave     : true
        };

        variables.conventions = {
            handlersLocation : "handlers",
            viewsLocation    : "views",
            layoutsLocation  : "layouts",
            modelsLocation   : "models",
            eventAction      : "index"
        };
    }

    function development(){
        variables.coldbox.customErrorTemplate = "/coldbox/system/exceptions/Whoops.cfm";
    }

}
