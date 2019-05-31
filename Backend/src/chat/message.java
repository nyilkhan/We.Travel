package chat;

public class message {
	public String Sender;
	public String Receiver;
	public String Body;
	public String Date;
	
	message(String sender, String receiver, String body, String date)
	{
		this.Sender = sender;
		this.Receiver = receiver;
		this.Date = date;
		this.Body = body;
	}
	
	public String GetReceiver()
	{
		return Receiver;
	}
	
	public String GetSender()
	{
		return Sender;
	}
	
	public String GetDate()
	{
		return Date;
	}
	
	public String GetBody()
	{
		return Body;
	}
}
