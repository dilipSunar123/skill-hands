package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "skill_reg_web")
public class SkillRegWebEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int applicationNo;
    private String name;
    private String dob;
    private String gender;
    private String fatName;
    private String motName;
    private String religion;
    private String tongue;
    private String langKnow;
    private String add1Per;
    private String add2Per;
    private String add3Per;
    private String districtCodePer;
    private String blockCodePer;
    private String poPer;
    private String pinPer;
    private String add1;
    private String add2;
    private String add3;
    private String phone;
    private String mobile;
    private String email;
    private String districtCode;
    private String blockCode;
    private String po;
    private String pin;
    private String epicNo;
    private String verifiedStatus;
    private String applyDate;





    @ManyToMany(mappedBy = "skillRegWebEntityList", cascade = CascadeType.ALL)
    List<SkillMasterEntity> skillMasterEntityList = new ArrayList<>();


//    @OneToOne
//    @JoinColumn(name = "application_no")
////    @Id
////    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    SkillRegWebPKEntity skillRegWebPKEntity = new SkillRegWebPKEntity();



    public SkillRegWebEntity() {}

    public SkillRegWebEntity(int applicationNo, String name, String dob, String gender, String fatName, String motName, String religion, String tongue, String langKnow, String add1Per, String add2Per, String add3Per, String districtCodePer, String blockCodePer, String poPer, String pinPer, String add1, String add2, String add3, String phone, String mobile, String email, String districtCode, String blockCode, String po, String pin, String epicNo, String verifiedStatus, String applyDate) {
        this.applicationNo = applicationNo;
        this.name = name;
        this.dob = dob;
        this.gender = gender;
        this.fatName = fatName;
        this.motName = motName;
        this.religion = religion;
        this.tongue = tongue;
        this.langKnow = langKnow;
        this.add1Per = add1Per;
        this.add2Per = add2Per;
        this.add3Per = add3Per;
        this.districtCodePer = districtCodePer;
        this.blockCodePer = blockCodePer;
        this.poPer = poPer;
        this.pinPer = pinPer;
        this.add1 = add1;
        this.add2 = add2;
        this.add3 = add3;
        this.phone = phone;
        this.mobile = mobile;
        this.email = email;
        this.districtCode = districtCode;
        this.blockCode = blockCode;
        this.po = po;
        this.pin = pin;
        this.epicNo = epicNo;
        this.verifiedStatus = verifiedStatus;
        this.applyDate = applyDate;
    }

    public int getApplicationNo() {
        return applicationNo;
    }

    public void setApplicationNo(int applicationNo) {
        this.applicationNo = applicationNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDob() {
        return dob;
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getFatName() {
        return fatName;
    }

    public void setFatName(String fatName) {
        this.fatName = fatName;
    }

    public String getMotName() {
        return motName;
    }

    public void setMotName(String motName) {
        this.motName = motName;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

    public String getTongue() {
        return tongue;
    }

    public void setTongue(String tongue) {
        this.tongue = tongue;
    }

    public String getLangKnow() {
        return langKnow;
    }

    public void setLangKnow(String langKnow) {
        this.langKnow = langKnow;
    }

    public String getAdd1Per() {
        return add1Per;
    }

    public void setAdd1Per(String add1Per) {
        this.add1Per = add1Per;
    }

    public String getAdd2Per() {
        return add2Per;
    }

    public void setAdd2Per(String add2Per) {
        this.add2Per = add2Per;
    }

    public String getAdd3Per() {
        return add3Per;
    }

    public void setAdd3Per(String add3Per) {
        this.add3Per = add3Per;
    }

    public String getDistrictCodePer() {
        return districtCodePer;
    }

    public void setDistrictCodePer(String districtCodePer) {
        this.districtCodePer = districtCodePer;
    }

    public String getBlockCodePer() {
        return blockCodePer;
    }

    public void setBlockCodePer(String blockCodePer) {
        this.blockCodePer = blockCodePer;
    }

    public String getPoPer() {
        return poPer;
    }

    public void setPoPer(String poPer) {
        this.poPer = poPer;
    }

    public String getPinPer() {
        return pinPer;
    }

    public void setPinPer(String pinPer) {
        this.pinPer = pinPer;
    }

    public String getAdd1() {
        return add1;
    }

    public void setAdd1(String add1) {
        this.add1 = add1;
    }

    public String getAdd2() {
        return add2;
    }

    public void setAdd2(String add2) {
        this.add2 = add2;
    }

    public String getAdd3() {
        return add3;
    }

    public void setAdd3(String add3) {
        this.add3 = add3;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDistrictCode() {
        return districtCode;
    }

    public void setDistrictCode(String districtCode) {
        this.districtCode = districtCode;
    }

    public String getBlockCode() {
        return blockCode;
    }

    public void setBlockCode(String blockCode) {
        this.blockCode = blockCode;
    }

    public String getPo() {
        return po;
    }

    public void setPo(String po) {
        this.po = po;
    }

    public String getPin() {
        return pin;
    }

    public void setPin(String pin) {
        this.pin = pin;
    }

    public String getEpicNo() {
        return epicNo;
    }

    public void setEpicNo(String epicNo) {
        this.epicNo = epicNo;
    }

    public String getVerifiedStatus() {
        return verifiedStatus;
    }

    public void setVerifiedStatus(String verifiedStatus) {
        this.verifiedStatus = verifiedStatus;
    }

    public String getApplyDate() {
        return applyDate;
    }

    public void setApplyDate(String applyDate) {
        this.applyDate = applyDate;
    }
}
