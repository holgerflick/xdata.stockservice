object ServerContainer: TServerContainer
  Height = 136
  Width = 382
  object Dispatcher: TSparkleHttpSysDispatcher
    Left = 72
    Top = 16
  end
  object Server: TXDataServer
    BaseUrl = 'http://+:80/'
    Dispatcher = Dispatcher
    InstanceLoopHandling = Error
    EntityLoopHandling = Error
    EntitySetPermissions = <>
    SwaggerOptions.Enabled = True
    SwaggerUIOptions.Enabled = True
    SwaggerUIOptions.ShowFilter = True
    SwaggerUIOptions.DisplayOperationId = True
    SwaggerUIOptions.TryItOutEnabled = True
    Left = 216
    Top = 16
    object MiddlewareCors: TSparkleCorsMiddleware
    end
  end
end
