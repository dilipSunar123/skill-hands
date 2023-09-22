package com.example.Skill.Hands.dto;

import java.io.Serializable;

public class FeedbackDto implements Serializable {

    private int id;
    private long skillHandId;
    private int citizenId;

    private String feedback;

    public FeedbackDto() {}

    public FeedbackDto(int id, long skillHandId, int citizenId, String feedback) {
        this.id = id;
        this.skillHandId = skillHandId;
        this.citizenId = citizenId;
        this.feedback = feedback;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getSkillHandId() {
        return skillHandId;
    }

    public void setSkillHandId(long skillHandId) {
        this.skillHandId = skillHandId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }
}
