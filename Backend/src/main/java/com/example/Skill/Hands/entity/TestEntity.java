package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "test_all_skills")
public class TestEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long id;
    @Column(name = "name", nullable = false)
    public String name;
    @Column(name = "address", nullable = false)
    public String address;
    @Column(name = "skill", nullable = false)
    public String skill;
    @Column(name = "experience", nullable = false)
    public String experience;
    @Column(name = "rating", nullable = false)
    public int rating;
    @Column(name = "contact", nullable = false)
    public String contact;
}
