page 50102 "EST API Purchase OrdersV2"
{
    APIGroup = 'ESTAPI';
    APIPublisher = 'YVS';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'estAPIPurchaseOrdersV2';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'ESTPurchaseOrderV2';
    EntitySetName = 'ESTPurchaseOrdersV2';
    PageType = API;
    SourceTable = "Purchase Header";
    SourceTableTemporary = false;
    //ODataKeyFields = "No.";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(No; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(noSeries; Rec."No. Series")
                {
                    Caption = 'No. Series';
                }

                field(Vendor_Name; Rec."Buy-from Vendor Name")
                {
                    Caption = 'Buy-from Vendor Name';
                }
                field(Vendor_No; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Buy-from Vendor No.';
                }

                part(PurchaseOrderLines; "EST API Purchase Order LinesV2")
                {
                    ApplicationArea = All;
                    Caption = 'Lines';
                    SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    EntityName = 'ESTPurchaseOrderLineV2';
                    EntitySetName = 'ESTPurchaseOrderLinesV2';
                }

            }
        }
    }

    // [ServiceEnabled]
    // procedure TestJsonPage(var actionContext: WebServiceActionContext)
    // var
    // begin


    //     actionContext.SetObjectType(ObjectType::Page);
    //     actionContext.SetObjectId(Page::"EST API Purchase Order LinesV2");
    //     actionContext.AddEntityKey(Rec.FIELDNO("No."), Rec."No.");

    //     // Set the result code to inform the caller that an item was created.
    //     actionContext.SetResultCode(WebServiceActionResultCode::Deleted);

    // end;

}

