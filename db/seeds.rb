names = [
  "Kebutaan",
  "Tuli",
  "Gangguan Mobilitas",
  "Disabilitas Kognitif",
  "Gangguan Bicara",
  "Kondisi Kesehatan Mental",
  "Penyakit Kronis",
  "Kesulitan Belajar",
  "Disabilitas Intelektual",
]

# Buat disabilitas
disabilities = names.map do |name|
  Disability.create!(
    name: name,
    description: case name
                 when "Kebutaan"
                   "Kondisi di mana seseorang kehilangan kemampuan untuk melihat sebagian atau seluruhnya."
                 when "Tuli"
                   "Kondisi di mana seseorang kehilangan sebagian atau seluruh kemampuan pendengaran."
                 when "Gangguan Mobilitas"
                   "Kesulitan dalam bergerak atau menggunakan bagian tubuh tertentu, biasanya mempengaruhi kemampuan untuk berjalan."
                 when "Disabilitas Kognitif"
                   "Kesulitan dalam fungsi mental yang memengaruhi kemampuan berpikir, belajar, dan memproses informasi."
                 when "Gangguan Bicara"
                   "Kesulitan dalam berbicara atau berkomunikasi secara verbal, yang bisa disebabkan oleh berbagai faktor."
                 when "Kondisi Kesehatan Mental"
                   "Kondisi yang memengaruhi suasana hati, pemikiran, dan perilaku, seperti depresi atau kecemasan."
                 when "Penyakit Kronis"
                   "Penyakit atau kondisi yang berlangsung lama dan memengaruhi kehidupan sehari-hari, seperti diabetes atau hipertensi."
                 when "Kesulitan Belajar"
                   "Gangguan dalam kemampuan belajar yang membuat seseorang kesulitan memahami atau menggunakan bahasa, matematika, atau keterampilan lainnya."
                 when "Disabilitas Intelektual"
                   "Kondisi yang memengaruhi kemampuan intelektual dan adaptasi seseorang, biasanya sejak lahir atau masa kanak-kanak."
                 else
                   "Deskripsi tidak tersedia."
                 end
  )
end
