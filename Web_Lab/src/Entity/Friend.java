package Entity;

public class Friend {
    private String ID;
    private String fromUID;
    private String toUID;
    private int status;

    public Friend(String ID, String fromUID, String toUID, int status) {
        this.ID = ID;
        this.fromUID = fromUID;
        this.toUID = toUID;
        this.status = status;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getFromUID() {
        return fromUID;
    }

    public void setFromUID(String fromUID) {
        this.fromUID = fromUID;
    }

    public String getToUID() {
        return toUID;
    }

    public void setToUID(String toUID) {
        this.toUID = toUID;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}