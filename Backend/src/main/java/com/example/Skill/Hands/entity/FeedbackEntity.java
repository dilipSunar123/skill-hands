package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "feedback_table")
public class FeedbackEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "citizen_id")
    private RegisterEntity registerEntity;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "skill_hand_id")
    private SkillsEntity skillsEntity;

    private String feedback;

    public FeedbackEntity() {}

    public FeedbackEntity(int id, RegisterEntity registerEntity, SkillsEntity skillsEntity, String feedback) {
        this.id = id;
        this.registerEntity = registerEntity;
        this.skillsEntity = skillsEntity;
        this.feedback = feedback;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public RegisterEntity getRegisterEntity() {
        return registerEntity;
    }

    public void setRegisterEntity(RegisterEntity registerEntity) {
        this.registerEntity = registerEntity;
    }

    public SkillsEntity getSkillsEntity() {
        return skillsEntity;
    }

    public void setSkillsEntity(SkillsEntity skillsEntity) {
        this.skillsEntity = skillsEntity;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }
}
