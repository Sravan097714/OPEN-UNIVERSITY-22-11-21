report 50131 "Import Module"
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
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);

        ExcelBuf.DELETEALL;

        MESSAGE('%1 lines have been uploaded.', gintCounter);
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

        ModuleUpload.INIT;
        ModuleUpload."Entry No." := 0;
        Evaluate(ModuleUpload."No.", GetValueAtCell(RowNo, 1));
        Evaluate(ModuleUpload.Description, GetValueAtCell(RowNo, 2));
        Evaluate(ModuleUpload."Common Module Code", GetValueAtCell(RowNo, 3));
        if GetValueAtCell(RowNo, 4) <> '' then
            Evaluate(ModuleUpload.Credit, GetValueAtCell(RowNo, 4));
        if GetValueAtCell(RowNo, 5) <> '' then
            Evaluate(ModuleUpload.Year, GetValueAtCell(RowNo, 5));
        if GetValueAtCell(RowNo, 6) <> '' then
            Evaluate(ModuleUpload.Semester, GetValueAtCell(RowNo, 6));
        ModuleUpload.INSERT(TRUE);
        gintCounter += 1;
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
        ModuleUpload: Record "Module Upload";
        gintCounter: Integer;

}

