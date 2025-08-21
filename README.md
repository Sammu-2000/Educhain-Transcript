EduChain Transcript Smart Contract  

A **decentralized transcript management system** built with [Clarity](https://docs.stacks.co/docs/write-smart-contracts/clarity) on the **Stacks blockchain**.  
EduChain enables **universities, colleges, and academic institutions** to issue, manage, and verify transcripts securely on-chain.  

Features  

Institution Management  
- Register academic institutions with a name and wallet address.  
- Retrieve institution details by ID.  
- Track the total number of registered institutions.  

Transcript Management  
- Registered institutions can issue transcripts for students.  
- Transcript includes:  
  - Student address  
  - Institution ID  
  - Course name  
  - Grade  
  - Year of completion  
- Verify transcripts publicly using their unique transcript ID.  

Validation & Security  
- Input validation for course names, grades, and year ranges (1900–2100).  
- Only institution wallets can issue transcripts.  
- Secure error handling with descriptive messages.  
- Event logs (`print`) for registration and issuance.  

Contract Structure  

- `institutions` → Stores registered institutions.  
- `transcripts` → Stores transcripts issued by institutions.  
- `institution-counter` & `transcript-counter` → Track unique IDs.  

Functions  
Institution Management  
- `register-institution (name wallet)` → Register a new institution.  
- `get-institution (institution-id)` → Fetch institution details.  
- `get-institution-count` → Get total number of registered institutions.  

Transcript Management  
- `issue-transcript (student institution-id course grade year)` → Issue a new transcript (only by the institution’s wallet).  
- `verify-transcript (transcript-id)` → Verify transcript details by ID.  
- `get-transcript-count` → Get total number of issued transcripts.  

Installation & Setup  

1. Clone this repository:  
   ```bash
   git clone https://github.com/your-username/educhain-transcript.git
   cd educhain-transcript
