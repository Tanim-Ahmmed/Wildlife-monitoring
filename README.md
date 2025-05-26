# 📘 PostgreSQL Basic SQL Interview Questions 

## 1. What is PostgreSQL?

**PostgreSQL** হলো একটি ওপেন সোর্স, রিলেশনাল ডেটাবেস ম্যানেজমেন্ট সিস্টেম (RDBMS) যা SQL-এর পাশাপাশি JSON, XML-এর মতো আধুনিক ডেটা টাইপও সাপোর্ট করে।

### বৈশিষ্ট্য:
- ACID properties মেনে চলে
- ট্রানজেকশনাল সাপোর্ট
- স্কেলেবল এবং মাল্টি-ইউজার সাপোর্ট
- Complex query, indexing, concurrency control সমর্থন করে

 **ব্যবহার:** ওয়েব অ্যাপ, ফিনান্স সফটওয়্যার, রিপোর্টিং সিস্টেম প্রভৃতি।

---

## 2. What is the purpose of a database schema in PostgreSQL?

**Schema** হলো ডেটাবেসের ভিতরের লজিক্যাল কাঠামো, যেখানে টেবিল, ভিউ, ফাংশন ইত্যাদি গ্রুপ করে রাখা হয়।

###  উদ্দেশ্য:
 - Data Organization: একাধিক ইউজার বা মডিউল থাকলে, ডেটা গুলোকে আলাদা স্কিমায় ভাগ করে গুছিয়ে রাখা যায়।

 - Namespace: স্কিমা একটি নেইমস্পেস হিসেবে কাজ করে, যার মাধ্যমে একই নামে একাধিক টেবিল বা অবজেক্ট থাকতে পারে, যদি তারা আলাদা স্কিমায় থাকে। যেমন:
  public.users , admin.users এখানে users টেবিল দুইটি আলাদা স্কিমায় অবস্থান করছে।

 - Access Control: স্কিমাভিত্তিক পারমিশন সেট করে নির্দিষ্ট ইউজারদের নির্দিষ্ট স্কিমা ব্যবহারে নিয়ন্ত্রণ রাখা যায়।

 - Modular Design: ভিন্ন ভিন্ন অ্যাপ্লিকেশন মডিউলের টেবিল, ফাংশন ইত্যাদি আলাদা স্কিমায় রেখে ডেটাবেসকে আরো মডুলার করা যায়।

 - Maintenance: একটি স্কিমা ড্রপ করলে তার সমস্ত অবজেক্ট একসাথে মুছে ফেলা যায় — রক্ষণাবেক্ষণের কাজ সহজ হয়।

#### উদাহরণ:
```sql
public.students
admin.students
```

## 3. Explain the Primary Key and Foreign Key concepts in PostgreSQL

### Primary Key:
PostgreSQL-এ Primary Key এমন একটি কলাম (বা একাধিক কলাম) যা প্রতিটি রেকর্ডকে ইউনিকভাবে শনাক্ত করে।

** বৈশিষ্ট্য:**
- NULL হতে পারে না
- ডুপ্লিকেট হতে পারে না
- একটি টেবিলে মাত্র একটি Primary Key থাকতে পারে

```sql
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  name TEXT
);
```


### Foreign Key:
**Foreign Key** এমন একটি কলাম যা অন্য একটি টেবিলের Primary Key কে রেফার করে এবং টেবিলগুলোর মধ্যে সম্পর্ক তৈরি করে।

*** বৈশিষ্ট্য:
- অন্য টেবিলের Primary Key বা Unique Key কে রেফার করে
- টেবিলগুলোর মধ্যে Referential Integrity বজায় রাখতে সাহায্য করে
- একটি টেবিলে একাধিক Foreign Key থাকতে পারে

#### উদাহরণ:
```sql
CREATE TABLE enrollments (
  enrollment_id SERIAL PRIMARY KEY,
  student_id INT REFERENCES students(student_id),
  course_name TEXT
);
```

## 4. What is the difference between the VARCHAR and CHAR data types?

 পার্থক্য টেবিল:

| বিষয়        | VARCHAR                          | CHAR                                    |
| ----------- | -------------------------------- | --------------------------------------- |
| Full Form   | Variable-length character        | Fixed-length character                  |
| Storage     | যতটুকু প্রয়োজন, ততটুকু জায়গা নেয় | নির্দিষ্ট দৈর্ঘ্যের জায়গা নেয়           |
| Padding     | না                               | হ্যাঁ (ফাঁকা জায়গা স্পেস দিয়ে পূরণ করে) |
| Performance | ছোট টেক্সট ডেটার জন্য ভালো       | নির্দিষ্ট দৈর্ঘ্যের ডেটার জন্য ভালো     |
| Usage       | নাম, ঠিকানা ইত্যাদি              | কোড, PIN, ফিক্সড ফিল্ড                  |

 **উদাহরণ:**

```sql
name VARCHAR(50)
pin_code CHAR(6)
```


## 5. What is the significance of the JOIN operation, and how does it work in PostgreSQL?  
`JOIN` ব্যবহার করে একাধিক টেবিলের মধ্যে সম্পর্ক তৈরি করে তাদের ডেটা একত্রে রিটার্ন করা হয়।

 JOIN ধরন:

| JOIN টাইপ    | ব্যাখ্যা                                    |
| ------------ | ------------------------------------------- |
| INNER JOIN   | শুধু মিল পাওয়া রেকর্ড রিটার্ন করে           |
| LEFT JOIN    | বাম টেবিলের সব রেকর্ড + মিল পাওয়া ডান টেবিল |
| RIGHT JOIN   | ডান টেবিলের সব রেকর্ড + মিল পাওয়া বাম টেবিল |
| FULL JOIN    | দুই টেবিলের সব রেকর্ড + NULL যদি না মেলে    |
| CROSS JOIN   | প্রত্যেক রেকর্ডের কম্বিনেশন                 |
| NATURAL JOIN | একই নামের কলামে JOIN হয়, ON ছাড়াই           |

**উদাহরণ:**

```sql
SELECT students.name, enrollments.course_name
FROM students
INNER JOIN enrollments ON students.student_id = enrollments.student_id;
```
## 6. Explain the GROUP BY clause and its role in aggregation operations.  
GROUP BY ক্লজ ব্যবহার করা হয় ডেটা গ্রুপ করে অ্যাগ্রিগেট ফাংশন চালাতে, যেমন: COUNT(), SUM()।

 **উদাহরণ:**

```sql
SELECT course_name, COUNT(*)
FROM enrollments
GROUP BY course_name;
```

 **সুবিধা:**

- বিভাগভিত্তিক বিশ্লেষণ করা যায়

- রিপোর্ট তৈরি সহজ হয়

- অ্যাগ্রিগেট ফাংশন প্রয়োগের সময় গ্রুপিং করা সম্ভব
