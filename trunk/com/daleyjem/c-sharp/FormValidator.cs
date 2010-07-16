using System;
using System.Collections.Generic;
using System.Web;
using System.Text.RegularExpressions;

/// <summary>
/// Summary description for FormValidator
/// </summary>
public class FormValidator
{
    private List<object> fieldTypeValues;
    public List<string> invalidFields;

	public FormValidator(){
        fieldTypeValues = new List<object>();
        invalidFields = new List<string>();
    }

    public void addField(string fieldName, FieldType fieldType, string fieldValue)
    {
        List<object> field = new List<object>();
        field.Add(fieldName);
        field.Add(fieldType);
        field.Add(fieldValue);
        fieldTypeValues.Add(field);
    }

    public bool validate()
    {
        bool isValid = true;
        foreach (List<object> field in fieldTypeValues)
        {
            if (!isFieldValid(field))
            {
                isValid = false;
                invalidFields.Add((string)field[0]);
            }
        }
        return isValid;
    }

    public enum FieldType
    {
        Email,
        Phone,
        URL,
        SSN,
        Integer,
        NonEmptyString
    }

    private bool isFieldValid(List<object> fieldTypeValue)
    {
        Regex regEx;
        string fieldValue = (string)fieldTypeValue[2];
        switch ((FieldType)fieldTypeValue[1])
        {
            case FieldType.Integer:
                regEx = new Regex(@"^\d+$");
                return regEx.IsMatch(fieldValue);
                break;
            case FieldType.Phone:
                regEx = new Regex(@"^[01]?[- .]?(\([2-9]\d{2}\)|[2-9]\d{2})[- .]?\d{3}[- .]?\d{4}$");
                return regEx.IsMatch(fieldValue);
                break;
            case FieldType.Email:
                regEx = new Regex(@"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
                return regEx.IsMatch(fieldValue);
                break;
            case FieldType.URL:
                regEx = new Regex(@"^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$");
                return regEx.IsMatch(fieldValue);
                break;
            case FieldType.SSN:
                regEx = new Regex(@"^\d{3}-\d{2}-\d{4}$");
                return regEx.IsMatch(fieldValue);
                break;
            case FieldType.NonEmptyString:
                return fieldValue.Trim().Length > 0;
                break;
        }
        return true;
    }
}