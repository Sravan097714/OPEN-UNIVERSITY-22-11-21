codeunit 50019 "Process Appl Submission Fee"
{

    TableNo = "OU Portal App Submission";
    trigger OnRun();
    begin
        ApplSubmissionFee := Rec;
        CreateJournal(ApplSubmissionFee);
        Rec := ApplSubmissionFee;
    end;

    local procedure CreateJournal(var ApplSubmissionFeePar: Record "OU Portal App Submission")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SalesReceivableSetup.Get;
        SalesReceivableSetup.TestField("G/L for Appl Submission Fee");
        SalesReceivableSetup.TestField("Appl Submission Amount");

        clear(GenJnlLine);

        if not grecGenJnlBatch.Get(JournalTemplateName, JournalBatchName) then
            Clear(grecGenJnlBatch);

        GenJnlLine2.Reset();
        GenJnlLine2.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine2.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine2.FindLast then
            GenJnlLine."Line No." := GenJnlLine2."Line No." + 10000
        else
            GenJnlLine."Line No." := 10000;

        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", JournalTemplateName);
        GenJnlLine.Validate("Journal Batch Name", JournalBatchName);
        GenJnlLine.SetUpNewLine(GenJnlLine2, 0, true);
        GenJnlLine.Validate("Document Type", GenJnlLine."Document Type"::Payment);
        //GenJnlLine.Validate("Document No.", NoSeriesMgt.GetNextNo(grecGenJnlBatch."No. Series", Today, false));
        GenJnlLine.Validate("Posting Date", Today);
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
        GenJnlLine.Validate("Account No.", SalesReceivableSetup."G/L for Appl Submission Fee");
        GenJnlLine.Validate(Amount, SalesReceivableSetup."Appl Submission Amount");
        GenJnlLine.Validate("Bal. Account Type", grecGenJnlBatch."Bal. Account Type");
        GenJnlLine.Validate("Bal. Account No.", grecGenJnlBatch."Bal. Account No.");
        GenJnlLine.Validate("Student ID", ApplSubmissionFeePar.User_ID);
        GenJnlLine."From OU Portal" := true;
        GenJnlLine.Insert();

        ApplSubmissionFeePar."NAV Doc No." := GenJnlLine."Document No.";
        ApplSubmissionFeePar.Modify();
    end;

    procedure SetJournal(JnlTemplate: Code[10]; JnlBatch: Code[10])
    begin
        JournalTemplateName := JnlTemplate;
        JournalBatchName := JnlBatch;
    end;

    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        ApplSubmissionFee: Record "OU Portal App Submission";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        grecGenJnlBatch: Record "Gen. Journal Batch";
}