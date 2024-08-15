pageextension 50108 "EST Sales Order Pro VYS" extends "EST Sales Order Pro"
{
    layout
    {
        addbefore("Shipment Method Code")
        {
            field("EST Route Name"; Rec."EST Route Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name field.', Comment = '%';
            }
            field("EST Route Name Description"; Rec."EST Route Name Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Route Name Description field.', Comment = '%';
            }
        }
        addafter("EST Document Status")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
                Editable = true;
            }
            field("EST For API SI"; Rec."EST For API SI")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Posting No. Series field.', Comment = '%';
            }
        }
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            var
                customer: Record Customer;
            begin
                if Rec."Sell-to Customer No." <> '' then begin
                    if customer.Get(Rec."Sell-to Customer No.") then begin
                        Rec."EST Route Name" := customer."EST Route Name";
                        Rec."EST Route Name Description" := customer."EST Route Name Description";
                        Rec."EST Dimension Route Code" := customer."EST Dimension Route Code";
                    end;
                end
                else begin
                    Rec."EST Route Name" := '';
                    Rec."EST Route Name Description" := '';
                    Rec."EST Dimension Route Code" := '';
                end;
            end;

            // trigger OnAfterAfterLookup(Selected: RecordRef)
            // var
            //     customer: Record Customer;
            // begin
            //     if Rec."Sell-to Customer No." <> '' then begin
            //         if customer.Get(Rec."Sell-to Customer No.") then begin
            //             Rec."EST Route Name" := customer."EST Route Name";
            //             Rec."EST Route Name Description" := customer."EST Route Name Description";
            //             Rec."EST Dimension Route Code" := customer."EST Dimension Route Code";
            //         end;
            //     end
            //     else begin
            //         Rec."EST Route Name" := '';
            //         Rec."EST Route Name Description" := '';
            //         Rec."EST Dimension Route Code" := '';
            //     end;
            // end;
        }
        //KT ++
        addafter("Sell-to Customer Name")
        {
            field("EST Is Deposit"; Rec."EST Is Deposit")
            {
                ApplicationArea = All;
            }
        }
        addafter("External Document No.")
        {
            field("EST PO Date"; Rec."EST PO Date")
            {
                ApplicationArea = All;
            }
        }
        //KT --
    }

    actions
    {
        // Add changes to page actions here
    }

}