export const suppliers = [
  {
    id: "SPL-2410-001",
    name: "PT Aqua Bekasi",
    address: "Jl. Raya Cibitung No. 12",
    googleMaps: "https://goo.gl/maps/example",
    paymentType: "cod",         // cod | dp | tempo
    paymentPeriod: "mingguan",  // harian | mingguan | bulanan
    products: [
      {
        name: "Galon 19L",
        merk: "Aqua",
        type: "Mineral",
        satuan: "pcs",
        price: 15000,
      },
      {
        name: "Cup 240ml",
        merk: "Aqua",
        type: "Mineral",
        satuan: "karton",
        price: 25000,
      },
    ],
  },
  {
    id: "SPL-2410-002",
    name: "CV Air Sejuk",
    address: "Jl. Mekarsari No. 7",
    googleMaps: null,
    paymentType: "tempo",
    paymentPeriod: "bulanan",
    products: [
      {
        name: "Air Isi Ulang",
        merk: "Sejuk",
        type: "RO",
        satuan: "galon",
        price: 12000,
      },
    ],
  },
];
