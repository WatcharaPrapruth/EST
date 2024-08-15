codeunit 50102 "EST Test conncet API"
{
    // procedure Ping(input: Integer): Integer
    // begin
    //     exit(-input);
    // end;

    // procedure Delay(delayMilliseconds: Integer)
    // begin
    //     Sleep(delayMilliseconds);
    // end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure TestConnect(): Text

    var
        JObject: JsonObject;
        OrderBody: JsonObject;

        TxtResponse: Text;
    begin
        JObject.Add('Status', 'Connect success');
        OrderBody.Add('Order', JObject.AsToken());
        JObject.WriteTo(TxtResponse);
        exit(TxtResponse);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure TestJson(): Text

    var
        JObject: JsonObject;
        OrderBody: JsonObject;

        Content: HttpContent;
        Headers: HttpHeaders;

        TxtResponse: Text;
    begin
        JObject.Add('Status', 'Connect success');
        OrderBody.Add('Order', JObject.AsToken());

        OrderBody.WriteTo(TxtResponse);
        Content.WriteFrom(TxtResponse);
        exit(TxtResponse);
    end;

    // [ServiceEnabled]
    // procedure CreateCustomerCopy(var actionContext : WebServiceActionContext)

    // var

    // createdCustomerGuid : Guid;

    // customer : Record Customer;

    // begin

    // actionContext.SetObjectType(ObjectType::Page);



    // actionContext.AddEntityKey(customer.fieldNo(Id), createdCustomerGuid);

    // actionContext.SetResultCode(WebServiceActionResultCode::Created);

    // end;
}