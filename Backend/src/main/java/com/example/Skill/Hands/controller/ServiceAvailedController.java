package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.dto.ServiceAvailedDto;
import com.example.Skill.Hands.entity.ServiceAvailedEntity;
import com.example.Skill.Hands.entity.ServicesMasterEntity;
import com.example.Skill.Hands.repository.RegisterRepo;
import com.example.Skill.Hands.repository.ServiceAvailedRepo;
import com.example.Skill.Hands.repository.ServiceMasterRepo;
import com.example.Skill.Hands.repository.SkillsRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Random;

@RestController
public class ServiceAvailedController {
    @Autowired
    private ServiceAvailedRepo serviceAvailedRepo;

    @Autowired
    private RegisterRepo registerRepo;

    @Autowired
    private SkillsRepo skillsRepo;

    @Autowired
    ServiceMasterRepo serviceMasterRepo;

    @GetMapping("/getAllServicesAvailed")
    public List<ServiceAvailedEntity> findServiceAvailed() {
        return serviceAvailedRepo.findAll();
    }

    @PostMapping("/addnewServiceAvailed")
    public ResponseEntity addnewServiceAvailed(@RequestBody ServiceAvailedDto serviceAvailedDto) {

        ServiceAvailedEntity entity = new ServiceAvailedEntity();

        entity.setRegisterEntity(registerRepo.getReferenceById((long) serviceAvailedDto.getCitizenId()));
        entity.setServicesMasterEntity(serviceMasterRepo.getReferenceById(serviceAvailedDto.getServiceId()));
        entity.setSkillsEntity(skillsRepo.getReferenceById( (long) serviceAvailedDto.getSkillHandId()));

        serviceAvailedRepo.save(entity);

        return ResponseEntity.ok("New Service Availed");
    }


    @GetMapping("/findByCitizenId/{citizenId}")
    public List<ServiceAvailedEntity> findByCitizenId(@PathVariable int citizenId) {

        return serviceAvailedRepo.findByRegisterEntityId(citizenId);

    }

    @GetMapping("/findByService/{serviceId}")
    public List<ServiceAvailedEntity> findByServiceMasterEntity(@PathVariable int serviceId) {
        return serviceAvailedRepo.findByServicesMasterEntityServiceId(serviceId);
    }


}
