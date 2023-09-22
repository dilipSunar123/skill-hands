package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "skill_reg_web_pk")
public class SkillRegWebPKEntity {

    @Id
    private long skillRegApplication;

    private int slno;

    public SkillRegWebPKEntity() {
    }



//    @OneToOne(mappedBy = "skillRegWebPKEntity", cascade = CascadeType.ALL)
//    SkillRegWebEntity skillRegWebEntity = new SkillRegWebEntity();



    public SkillRegWebPKEntity(long skillRegApplication, int slno) {
        this.skillRegApplication = skillRegApplication;
        this.slno = slno;
    }

    public long getSkillRegApplication() {
        return skillRegApplication;
    }

    public void setSkillRegApplication(long skillRegApplication) {
        this.skillRegApplication = skillRegApplication;
    }

    public int getSlno() {
        return slno;
    }

    public void setSlno(int slno) {
        this.slno = slno;
    }
}
