package Entity;

import java.sql.Timestamp;

public class User {
    private String ID;
    private String email;
    private String userName;
    private String pass;
    private Integer state;
    private Timestamp dateJoined;
    private Timestamp dateLastModified;

    public User(String ID, String email, String userName, String pass, Integer state, Timestamp dateJoined) {
        this.ID = ID;
        this.email = email;
        this.userName = userName;
        this.pass = pass;
        this.state = state;
        this.dateJoined = dateJoined;
    }

    @Override
    public String toString() {
        return "User{" +
                "ID='" + ID + '\'' +
                ", email='" + email + '\'' +
                ", userName='" + userName + '\'' +
                ", pass='" + pass + '\'' +
                ", state=" + state +
                ", dateJoined=" + dateJoined +
                ", dateLastModified=" + dateLastModified +
                '}';
    }

    public User() {
    }

    public String getID() {
        return ID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Timestamp getDateJoined() {
        return dateJoined;
    }

    public void setDateJoined(Timestamp dateJoined) {
        this.dateJoined = dateJoined;
    }

    public Timestamp getDateLastModified() {
        return dateLastModified;
    }

    public void setDateLastModified(Timestamp dateLastModified) {
        this.dateLastModified = dateLastModified;
    }
}
