package com.example.Skill.Hands.entity;

import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;

import java.sql.Date;


@Entity
@Table(name = "services_availed")
public class ServiceAvailedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "serviceId")
    private ServicesMasterEntity servicesMasterEntity;

    // citized
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "citizenId")
    private RegisterEntity registerEntity;

    // skill hand
    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "skillHandId")
    private SkillsEntity skillsEntity;

//    @CreatedDate
    @Column(name = "START_DATE", columnDefinition = "DATE DEFAULT ('now'::text)::date")
    private Date serviceAvailedDate;
    public ServiceAvailedEntity() {}

    public ServiceAvailedEntity(int id, ServicesMasterEntity servicesMasterEntity, RegisterEntity registerEntity, SkillsEntity skillsEntity, Date serviceAvailedDate) {
        this.id = id;
        this.servicesMasterEntity = servicesMasterEntity;
        this.registerEntity = registerEntity;
        this.skillsEntity = skillsEntity;
        this.serviceAvailedDate = serviceAvailedDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public ServicesMasterEntity getServicesMasterEntity() {
        return servicesMasterEntity;
    }

    public void setServicesMasterEntity(ServicesMasterEntity servicesMasterEntity) {
        this.servicesMasterEntity = servicesMasterEntity;
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

    public Date getServiceAvailedDate() {
        return serviceAvailedDate;
    }

    public void setServiceAvailedDate(Date serviceAvailedDate) {
        this.serviceAvailedDate = serviceAvailedDate;
    }
}
