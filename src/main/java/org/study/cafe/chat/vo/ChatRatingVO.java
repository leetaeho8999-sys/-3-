package org.study.cafe.chat.vo;

public class ChatRatingVO {
    private int    id;
    private String botMessage;
    private String rating; // "good" or "bad"

    public int    getId()          { return id; }
    public void   setId(int id)    { this.id = id; }
    public String getBotMessage()  { return botMessage; }
    public void   setBotMessage(String botMessage) { this.botMessage = botMessage; }
    public String getRating()      { return rating; }
    public void   setRating(String rating)         { this.rating = rating; }
}
