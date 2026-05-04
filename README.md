# Secure Legacy Modernization: Strangler Pattern Implementation for FedRAMP Environments

> **Project Goal:** Demonstrate a secure, incremental migration of a mission-critical legacy monolith to a cloud-native microservices architecture on AWS, adhering to FedRAMP High compliance principles.

## 🏗️ Architecture Overview

This project simulates the **"Strangler Fig" pattern**, where specific functionalities (Authentication, Transactions) are gradually extracted from a legacy Java monolith into independent Spring Boot microservices. Traffic is routed via an API Gateway, allowing for zero-downtime migration.

### High-Level Architecture Diagram

The diagram below illustrates the traffic flow from the Angular Frontend through the API Gateway, splitting between the **Legacy Monolith** (Phase 1) and the **New Microservices** (Phase 2).

```mermaid
graph TD
    Client[Angular Frontend] -->|HTTPS| GW[AWS API Gateway / Spring Cloud Gateway]
    
    subgraph "Legacy Monolith Phase 1"
        Mono[Legacy Spring Boot App Port 8080]
    end
    
    subgraph "New Microservices Phase 2"
        Auth[Auth Service JWT Port 8081]
        Trans[Transaction Service EventBridge Port 8082]
    end
    
    GW -->|/api/auth| Auth
    GW -->|/api/transactions| Trans
    GW -->|/legacy/*| Mono
    
    Auth --> DB[(Encrypted RDS PostgreSQL)]
    Trans --> DB
    Mono --> DB
    
    style Mono fill:#ffcccc,stroke:#cc0000,stroke-width:2px
    style Auth fill:#ccffcc,stroke:#006600,stroke-width:2px
    style Trans fill:#ccffcc,stroke:#006600,stroke-width:2px
    style GW fill:#ffffcc,stroke:#cc9900,stroke-width:2px
