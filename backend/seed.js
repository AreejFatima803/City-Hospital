const Doctor = require('./models/Doctor');
const specs = ['General Physicians','General Surgeon','Gynaecologist','Gastroenterologist','Orthopedics','Paediatrician','Paediatric Surgeons','Paediatric Nephrologist','Paediatric Cardiologist','E.N.T','Ophthalmologist','Cardiologist','Nephrologist','Neuro Surgeon','Neurologist','Anesthesia','Pathologist','Pulmonologist','Cosmetic Surgeon','Radiologist','Urologist'];
const names = ['Dr. Ahmed Khan','Dr. Sara Malik','Dr. Usman Ali','Dr. Ayesha Noor','Dr. Bilal Hussain','Dr. Fatima Zahra'];
const times = ['Mon-Fri, 9:00 AM - 1:00 PM','Mon-Sat, 2:00 PM - 6:00 PM','Tue-Sun, 5:00 PM - 9:00 PM'];

module.exports = async () => {
  if (await Doctor.countDocuments()) return;
  const docs = [];
  specs.forEach((s, i) => {
    for (let k = 0; k < 3; k++) {
      const n = (i + k * 2) % names.length;
      docs.push({ name: names[n], specialization: s, timings: times[k],
        image: `https://i.pravatar.cc/200?img=${(i * 3 + k) % 70 + 1}` });
    }
  });
  await Doctor.insertMany(docs);
  console.log('Seeded', docs.length, 'doctors');
};
