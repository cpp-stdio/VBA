Attribute VB_Name = "Involved_Call"
Option Explicit
'##############################################################################################################################
'
'   �Z���֘A
'
'   �V�K�쐬�� : 2022/11/10
'   �ŏI�X�V�� : 2022/11/11
'
'   �V�K�쐬�G�N�Z���o�[�W���� : Office Professional Plus 2016 , 16.0.5.56.1000(32�r�b�g)
'   �ŏI�X�V�G�N�Z���o�[�W���� : Office Professional Plus 2016 , 16.0.5.56.1000(32�r�b�g)
'
'##############################################################################################################################

'==============================================================================================================================
'   �Z�����œ��͂���Ă��鐔����l�ɕϊ�����
'   ��1�@���p����ꍇ�́uInvolved_Other.bas�v�̃C���|�[�g�����肢���܂�
'   ��2�@���������̎����Čv�Z���s���̂œ��삪�d���Ȃ�\��������܂�
'   ��3�@�uInvolved_Sheet�v�ɃV�[�g���S�Ă̐�����l�ɕϊ�����v���O����������܂�
'
'   �߂�l : �ϊ�����(True), NG(False)
'
'   Range : �Z��������́AWorksheet����Cells��Range�͎��͓����^
'   rowMax : �ύX�͈́i�C�Ӂj
'   columnMax : �ύX�͈́i�C�Ӂj
'   sheetName : �V�[�g��
'==============================================================================================================================
Public Function cellsDeleteFormula(ByRef cells As Range, Optional ByVal rowMax As Long = 0, Optional ByVal columnMax As Long = 0) As Boolean
    cellsDeleteFormula = False
    If cells Is Nothing Then Exit Function
    
    Dim cell As Range
    Dim row As Long
    Dim column As Long
    Dim text As String
    Dim value As Variant
    
    '�����͂̏ꍇ��Max�l�Ɣ��f
    If rowMax <= 0 Then rowMax = cells.Rows.Count - 1
    If columnMax <= 0 Then columnMax = cells.column.Count - 1
    
    For row = rowMax To 0 Step -1
        For column = columnMax To 0 Step -1
            Set cell = cells.Offset(row, column)
            
            If WorksheetFunction.IsFormula(cell) Then
                cell.Calculate '�Čv�Z
                text = cell.value
                '���l�̏ꍇ�͂��̂܂�"���l"�Ƃ��ĕ\��������i���t�A���z���͑ΏۊO�j
                If checkNumericalValue(text, value) Then
                    cell.value = value
                Else
                    cell.NumberFormatLocal = "@"
                    cell.value = text
                End If
            End If
        Next
    Next
    
    Set cell = Nothing
    cellsDeleteFormula = True
End Function
