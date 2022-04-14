report 50030 "Import Module Fee OU Portal"
{
    ProcessingOnly = true;
    //UsageCategory = Administration;
    //ApplicationArea = All;

    RequestPage
    {
        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            IF CloseAction = ACTION::OK THEN BEGIN
                ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);
            END;
        end;
    }


    trigger OnPreReport()
    begin
        gintCounter := 0;
        //grecModuleFromOUPortal.DeleteAll();
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;

        MESSAGE('%1 lines have been uploaded in the system for Module Fees.', gintCounter);
    end;


    PROCEDURE GetLastRowandColumn();
    BEGIN
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    END;


    PROCEDURE GetValueAtCell(RowNo: Integer; ColNo: Integer): Text;
    VAR
        ExcelBuf1: Record 370;
    BEGIN
        if ExcelBuf1.GET(RowNo, ColNo) then
            EXIT(ExcelBuf1."Cell Value as Text")
        else
            exit('');
    END;


    PROCEDURE InsertData(RowNo: Integer);
    BEGIN
        grecModuleFromOUPortal2.Reset();
        if grecModuleFromOUPortal2.FindLast then
            EntryNo := grecModuleFromOUPortal2."Line No." + 1
        else
            EntryNo := 1;

        grecModuleFromOUPortal.INIT;
        EVALUATE(grecModuleFromOUPortal."Line No.", format(EntryNo));
        Evaluate(grecModuleFromOUPortal.RDAP, GetValueAtCell(RowNo, 2));
        Evaluate(grecModuleFromOUPortal.RDBL, GetValueAtCell(RowNo, 3));
        Evaluate(grecModuleFromOUPortal.NIC, GetValueAtCell(RowNo, 4));
        Evaluate(grecModuleFromOUPortal."Learner ID", GetValueAtCell(RowNo, 5));
        Evaluate(grecModuleFromOUPortal."First Name", GetValueAtCell(RowNo, 6));
        Evaluate(grecModuleFromOUPortal."Last Name", GetValueAtCell(RowNo, 7));
        Evaluate(grecModuleFromOUPortal."Maiden Name", GetValueAtCell(RowNo, 8));

        if GetValueAtCell(RowNo, 9) <> '' then begin
            grecGenLedgSetup.get;
            Evaluate(gdateDim2, GetValueAtCell(RowNo, 9));

            grecDimValue.Reset();
            grecDimValue.SetRange("Dimension Code", grecGenLedgSetup."Global Dimension 2 Code");
            grecDimValue.SetFilter("Starting Date", '>=%1', gdateDim2);
            if grecDimValue.Findfirst then begin
                repeat
                    if gdateDim2 <= grecDimValue."Ending Date" then
                        grecModuleFromOUPortal."Shortcut Dimension 2 Code" := grecDimValue.Code;
                until (grecDimValue.Next = 0) or (grecModuleFromOUPortal2."Shortcut Dimension 2 Code" <> '');
            end;

            Evaluate(grecModuleFromOUPortal."Login Email", GetValueAtCell(RowNo, 11));
            Evaluate(grecModuleFromOUPortal."Contact Email", GetValueAtCell(RowNo, 12));
            //Shortcut Dimension
            EVALUATE(grecModuleFromOUPortal."Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 14));



            //Module 1
            Evaluate(grecModuleFromOUPortal."Module ID 1", GetValueAtCell(RowNo, 15));
            Evaluate(grecModuleFromOUPortal."Module Description 1", GetValueAtCell(RowNo, 16));
            Evaluate(grecModuleFromOUPortal."No. 1", GetValueAtCell(RowNo, 17));
            Evaluate(grecModuleFromOUPortal."Common Module Code 1", GetValueAtCell(RowNo, 18));
            if GetValueAtCell(RowNo, 19) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 1", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 1", GetValueAtCell(RowNo, 19));

            if GetValueAtCell(RowNo, 20) = '' then
                Evaluate(grecModuleFromOUPortal."Module 1 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 1 Fee Ins", GetValueAtCell(RowNo, 20));

            if GetValueAtCell(RowNo, 21) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 1", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 1", GetValueAtCell(RowNo, 21));


            //Module 2
            Evaluate(grecModuleFromOUPortal."Module ID 2", GetValueAtCell(RowNo, 22));
            Evaluate(grecModuleFromOUPortal."Module Description 2", GetValueAtCell(RowNo, 23));
            Evaluate(grecModuleFromOUPortal."No. 2", GetValueAtCell(RowNo, 24));
            Evaluate(grecModuleFromOUPortal."Common Module Code 2", GetValueAtCell(RowNo, 25));
            if GetValueAtCell(RowNo, 26) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 2", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 2", GetValueAtCell(RowNo, 26));

            if GetValueAtCell(RowNo, 27) = '' then
                Evaluate(grecModuleFromOUPortal."Module 2 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 2 Fee Ins", GetValueAtCell(RowNo, 27));

            if GetValueAtCell(RowNo, 28) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 2", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 2", GetValueAtCell(RowNo, 28));


            //Module 3
            Evaluate(grecModuleFromOUPortal."Module ID 3", GetValueAtCell(RowNo, 29));
            Evaluate(grecModuleFromOUPortal."Module Description 3", GetValueAtCell(RowNo, 30));
            Evaluate(grecModuleFromOUPortal."No. 3", GetValueAtCell(RowNo, 31));
            Evaluate(grecModuleFromOUPortal."Common Module Code 3", GetValueAtCell(RowNo, 32));
            if GetValueAtCell(RowNo, 33) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 3", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 3", GetValueAtCell(RowNo, 33));

            if GetValueAtCell(RowNo, 34) = '' then
                Evaluate(grecModuleFromOUPortal."Module 3 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 3 Fee Ins", GetValueAtCell(RowNo, 34));

            if GetValueAtCell(RowNo, 35) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 3", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 3", GetValueAtCell(RowNo, 35));


            //Module 4
            Evaluate(grecModuleFromOUPortal."Module ID 4", GetValueAtCell(RowNo, 36));
            Evaluate(grecModuleFromOUPortal."Module Description 4", GetValueAtCell(RowNo, 37));
            Evaluate(grecModuleFromOUPortal."No. 4", GetValueAtCell(RowNo, 38));
            Evaluate(grecModuleFromOUPortal."Common Module Code 4", GetValueAtCell(RowNo, 39));
            if GetValueAtCell(RowNo, 40) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 4", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 4", GetValueAtCell(RowNo, 40));

            if GetValueAtCell(RowNo, 41) = '' then
                Evaluate(grecModuleFromOUPortal."Module 4 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 4 Fee Ins", GetValueAtCell(RowNo, 41));

            if GetValueAtCell(RowNo, 42) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 4", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 4", GetValueAtCell(RowNo, 42));


            //Module 5
            Evaluate(grecModuleFromOUPortal."Module ID 5", GetValueAtCell(RowNo, 43));
            Evaluate(grecModuleFromOUPortal."Module Description 5", GetValueAtCell(RowNo, 44));
            Evaluate(grecModuleFromOUPortal."No. 5", GetValueAtCell(RowNo, 45));
            Evaluate(grecModuleFromOUPortal."Common Module Code 5", GetValueAtCell(RowNo, 46));
            if GetValueAtCell(RowNo, 47) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 5", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 5", GetValueAtCell(RowNo, 47));

            if GetValueAtCell(RowNo, 48) = '' then
                Evaluate(grecModuleFromOUPortal."Module 5 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 5 Fee Ins", GetValueAtCell(RowNo, 48));
            if GetValueAtCell(RowNo, 49) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 5", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 5", GetValueAtCell(RowNo, 49));


            //Module 6
            Evaluate(grecModuleFromOUPortal."Module ID 5", GetValueAtCell(RowNo, 50));
            Evaluate(grecModuleFromOUPortal."Module Description 6", GetValueAtCell(RowNo, 51));
            Evaluate(grecModuleFromOUPortal."No. 6", GetValueAtCell(RowNo, 52));
            Evaluate(grecModuleFromOUPortal."Common Module Code 6", GetValueAtCell(RowNo, 53));
            if GetValueAtCell(RowNo, 54) = '' then
                Evaluate(grecModuleFromOUPortal."Module Amount 6", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Amount 6", GetValueAtCell(RowNo, 54));

            if GetValueAtCell(RowNo, 55) = '' then
                Evaluate(grecModuleFromOUPortal."Module 6 Fee Ins", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module 6 Fee Ins", GetValueAtCell(RowNo, 55));
            if GetValueAtCell(RowNo, 56) = '' then
                Evaluate(grecModuleFromOUPortal."Module Credit 6", '0')
            else
                Evaluate(grecModuleFromOUPortal."Module Credit 6", GetValueAtCell(RowNo, 56));

            Evaluate(grecModuleFromOUPortal."Phone No.", GetValueAtCell(RowNo, 57));
            Evaluate(grecModuleFromOUPortal."Mobile No.", GetValueAtCell(RowNo, 58));
            Evaluate(grecModuleFromOUPortal.Address, copystr(GetValueAtCell(RowNo, 59), 1, MaxStrLen(grecModuleFromOUPortal.Address)));
            Evaluate(grecModuleFromOUPortal."Address 2", copystr(GetValueAtCell(RowNo, 59), 101, MaxStrLen(grecModuleFromOUPortal."Address 2")));
            Evaluate(grecModuleFromOUPortal.Country, GetValueAtCell(RowNo, 60));

            if GetValueAtCell(RowNo, 61) = 'yes' then
                grecModuleFromOUPortal."Gov Grant" := true;

            Evaluate(grecModuleFromOUPortal.Status, GetValueAtCell(RowNo, 62));

            if (GetValueAtCell(RowNo, 63) <> '') AND (GetValueAtCell(RowNo, 63) <> 'Rs') then
                grecModuleFromOUPortal.Currency := 'USD';

            if GetValueAtCell(RowNo, 64) = 'yes' then
                grecModuleFromOUPortal.Instalment := true;

            if GetValueAtCell(RowNo, 65) <> '' then
                Evaluate(grecModuleFromOUPortal."Payment Amount", GetValueAtCell(RowNo, 65));

            grecModuleFromOUPortal."Portal Payment Mode" := GetValueAtCell(RowNo, 66);
            grecModuleFromOUPortal."MyT Money Ref" := GetValueAtCell(RowNo, 67);
            Evaluate(grecModuleFromOUPortal."Payment Date", GetValueAtCell(RowNo, 68));
            EVALUATE(grecModuleFromOUPortal."Posting Date", GetValueAtCell(RowNo, 68));
            grecModuleFromOUPortal."Customer ID" := GetValueAtCell(RowNo, 69);

            grecModuleFromOUPortal."Imported By" := UserId;
            grecModuleFromOUPortal."Imported On" := CurrentDateTime;

            grecModuleFromOUPortal.INSERT(TRUE);
            gintCounter += 1;
        END;
    END;


    var
        ExcelBuf: Record "Excel Buffer";
        ServerFileName: Text[250];
        SheetName: Text[250];
        TotalRows: Integer;
        TotalColumns: Integer;
        FileMgt: Codeunit "File Management";
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx';
        X: Integer;
        grecModuleFromOUPortal: Record "Module Fee From OU Portal";
        grecModuleFromOUPortal2: Record "Module Fee From OU Portal";
        EntryNo: Integer;
        grecSalesHeader: Record "Sales Header";
        grecSalesLine: Record "Sales Line";
        grecSalesLine2: Record "Sales Line";
        gtextSalesOrderNo: Text[50];
        gcodeCustomerno: code[20];
        gdatePostingDate: Date;
        grecCustomer: Record Customer;
        grecItem: Record Item;
        grecSalesReceivableSetup: Record "Sales & Receivables Setup";
        grecGenLedgSetup: Record "General Ledger Setup";
        gdateDim2: Date;
        grecDimValue: Record "Dimension Value";
        glblDimError: Label 'Shortcut Dimension %1 does not exist.';
        glblModuleError: Label 'Module code %1 does not exist.';
        grecCustomer2: Record Customer;
        gintCounter: Integer;
}

