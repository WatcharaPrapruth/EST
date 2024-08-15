codeunit 50101 "EST API Management YVS"
{
    Permissions = tabledata "Sales Invoice Header" = RIMD;
    procedure UpdateSalesInvoiceHeadAPIComplete(var salesInvoiceHeader: Record "Sales Invoice Header"; staut: Boolean)
    var
        myInt: Integer;
    begin
        salesInvoiceHeader."EST API Completed" := staut;
        salesInvoiceHeader.Modify();
        //Commit();
    end;

    procedure UpdateSalesInvoiceHeadForAPI(var salesInvoiceHeader: Record "Sales Invoice Header"; staut: Boolean)
    var
        myInt: Integer;
    begin
        salesInvoiceHeader."EST For API SI" := staut;
        salesInvoiceHeader.Modify();
        //Commit();
    end;

    procedure GetForAPI(var No: Code[20]; var Type: Enum "EST For API Type"): Boolean
    var
        noSeries: Record "No. Series";
        ret: Boolean;
    begin
        if no = '' then
            exit(false);

        IF NOT noSeries.GET(No) THEN
            noSeries.INIT();

        if Type = "EST For API Type"::"For API PO" then
            ret := noSeries."EST For API PO";

        if Type = "EST For API Type"::"For API SI" then
            ret := noSeries."EST For API SI";

        exit(ret);
    end;

    procedure InsertAPILog(ActionPage: Enum "EST Action Page"; MethodType: Enum "EST Method Type"; Direction: Enum "EST Direction"; JsonReq_log: Text; TxtResponse: Text; StatusInterface: Enum "EST Status Interface"; Key1: Code[30]; Key2: Code[30]; ErrorTxt: Text; var RefId: Integer)
    var
        APILog: Record "EST Interface Log";
    begin
        APILog.INIT;
        APILog."EST Method Type" := MethodType;
        APILog."EST Action Page" := ActionPage;
        APILog."EST Direction" := Direction;
        APILog."EST Status" := StatusInterface;
        case APILog."EST Action Page" of
            "EST Action Page"::"Sales Order":
                begin
                    APILog."EST Primary Key Caption" := StrSubstNo('[1: No., 2: Customer No.]');
                end;
        end;
        APILog."EST Primary Key Value 1" := Key1;
        APILog."EST Primary Key Value 2" := Key2;
        APILog.INSERT(true);
        RefId := APILog."EST Entry No.";
        if APILog."EST Status" = "EST Status Interface"::Failed then
            SetAPIDetail(APILog, APILog.FIELDNO("EST Description"), ErrorTxt, TEXTENCODING::UTF8);
        SetAPIDetail(APILog, APILog.FIELDNO("EST Json Log"), JsonReq_log, TEXTENCODING::UTF8);
        SetAPIDetail(APILog, APILog.FIELDNO("EST Response Log"), TxtResponse, TEXTENCODING::UTF8);
    end;

    local procedure SetAPIDetail(var APILog: Record "EST Interface Log"; FIELDNO: Integer; JsonTxt: Text; pEncoding: TextEncoding)
    var
        OutStream: OutStream;
    begin
        IF JsonTxt = '' THEN
            EXIT;

        CASE FIELDNO OF
            APILog.FIELDNO("EST Description"):
                BEGIN
                    Clear(APILog."EST Description");
                    APILog."EST Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
                END;
            APILog.FIELDNO("EST Json Log"):
                BEGIN
                    CLEAR(APILog."EST Json Log");
                    APILog."EST Json Log".CreateOutStream(OutStream, TEXTENCODING::UTF8);
                END;
            APILog.FIELDNO("EST Response Log"):
                BEGIN
                    Clear(APILog."EST Response Log");
                    APILog."EST Response Log".CreateOutStream(OutStream, TEXTENCODING::UTF8);
                END;
        END;
        OutStream.WriteText(JsonTxt);
        IF APILog.MODIFY THEN;
    end;

    procedure GetJsonToken(PJsonObject: JsonObject; PKey: Text): JsonToken
    var
        JNameToken: JsonToken;
    begin
        PJsonObject.Get(PKey, JNameToken);
        exit(JNameToken);
    end;

}