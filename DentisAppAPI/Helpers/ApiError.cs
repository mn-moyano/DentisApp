namespace DentisAppAPI.Helpers
{
    public class ApiError
    {
        public bool Success => false;

        public int StatusCode { get; set; }

        public string Message { get; set; } = string.Empty;

        public DateTime Timestamp { get; set; }
    }
}