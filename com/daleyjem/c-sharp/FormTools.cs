using System;
using System.Collections.Generic;
using System.Web;
using System.Text.RegularExpressions;

/// <summary>
/// Summary description for FormTools
/// </summary>
public class FormTools
{
	public FormTools(){}

    /// <summary>
    /// Trims all characters except numbers from a phone number value
    /// </summary>
    /// <param name="phoneNumber"></param>
    /// <returns></returns>
    public static string stripPhoneNumber(string phoneNumber)
    {
        Regex digitsOnly = new Regex(@"[^\d]");
        return digitsOnly.Replace(phoneNumber, "");
    }
}
