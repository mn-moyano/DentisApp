namespace DentisAppAPI.Helpers;

public class ApiError
{
    public bool Success => false;

    public string Message { get; set; } = string.Empty;
}