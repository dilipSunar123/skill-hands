package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "skills_master")
public class SkillMasterEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int skillId;
    private String skillName;
    private String description;

    @ManyToMany
    List<SkillRegWebEntity> skillRegWebEntityList = new ArrayList<>();

    public SkillMasterEntity() {}

    public SkillMasterEntity(int skillId, String skillName, String description) {
        this.skillId = skillId;
        this.skillName = skillName;
        this.description = description;
    }

    public int getSkillId() {
        return skillId;
    }

    public void setSkillId(int skillId) {
        this.skillId = skillId;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
