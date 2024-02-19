from datetime import datetime, timedelta

start_date = datetime(2024, 5, 1)
end_date = datetime(2024, 5, 31)
delta = timedelta(days=1)
while start_date <= end_date:
    print(f"('NH116', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',"
          f"146, 21, 48, NULL,"
          f"1000.00, 1300.00, 4500.00, NULL,"
          f"'Tokyo', 'Japan', 'Vancouver', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 21:55:00', '{start_date.strftime('%Y-%m-%d')} 13:45:00', '10:30'),")
    start_date += delta


'''
while start_date <= end_date:
    landing_date = start_date + timedelta(days=1)
    print(f"('NH115', '2 checked luggages included, 23kg each', 'All Nippon Airways', 'Boeing 787-9 Dreamliner',"
          f"146, 21, 48, NULL,"
          f"1000.00, 1300.00, 4500.00, NULL,"
          f"'Vancouver', 'Canada', 'Tokyo', 'Japan',"
          f"'{start_date.strftime('%Y-%m-%d')} 15:15:00', '{landing_date.strftime('%Y-%m-%d')} 18:45:00', '10:30'),")
    start_date += delta


while start_date <= end_date:
    print(f"('AC004', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',"
          f"236, 24, 40, NULL,"
          f"900.00, 1200.00, 4000.00, NULL,"
          f"'Tokyo', 'Japan', 'Vancouver', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 18:55:00', '{start_date.strftime('%Y-%m-%d')} 10:40:00', '11:30'),")
    start_date += delta


while start_date <= end_date:
    landing_date = start_date + timedelta(days=1)
    print(f"('AC003', '2 checked luggages included, 23kg each', 'Air Canada', 'Boeing 777-300ER',"
          f"236, 24, 40, NULL,"
          f"900.00, 1200.00, 4000.00, NULL,"
          f"'Vancouver', 'Canada', 'Tokyo', 'Japan',"
          f"'{start_date.strftime('%Y-%m-%d')} 13:00:00', '{landing_date.strftime('%Y-%m-%d')} 16:50:00', '11:30'),")
    start_date += delta


while start_date <= end_date:
    print(f"('AC414', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',"
          f"125, NULL, 12, NULL,"
          f"150.00, NULL, 500.00, NULL,"
          f"'Toronto', 'Canada', 'Montreal', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 14:00:00', '{start_date.strftime('%Y-%m-%d')} 15:20:00', '00:45'),")
    start_date += delta

while start_date <= end_date:
    print(f"('AC413', 'No checked luggages included', 'Air Canada', 'Airbus A220-300',"
          f"125, NULL, 12, NULL,"
          f"150.00, NULL, 500.00, NULL,"
          f"'Montreal', 'Canada', 'Toronto', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 13:10:00', '{start_date.strftime('%Y-%m-%d')} 14:46:00', '00:45'),")
    start_date += delta


while start_date <= end_date:
    print(f"('AC406', 'No checked luggages included', 'Air Canada', 'Airbus A321',"
          f"174, NULL, 16, NULL,"
          f"120.00, NULL, 400.00, NULL,"
          f"'Toronto', 'Canada', 'Montreal', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 10:00:00', '{start_date.strftime('%Y-%m-%d')} 11:16:00', '00:45'),")
    start_date += delta

while start_date <= end_date:
    print(f"('AC306', 'No checked luggages included', 'Air Canada', 'Boeing 737 MAX 8',"
          f"153, NULL, 16, NULL,"
          f"300.00, NULL, 1000.00, NULL,"
          f"'Vancouver', 'Canada', 'Montreal', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 11:30:00', '{start_date.strftime('%Y-%m-%d')} 19:19:00', '4:30'),")
    start_date += delta

while start_date <= end_date:
    print(f"('AC405', 'No checked luggages included', 'Air Canada', 'Airbus A321',"
          f"174, NULL, 16, NULL,"
          f"120.00, NULL, 400.00, NULL,"
          f"'Montreal', 'Canada', 'Toronto', 'Canada',"
          f"'{start_date.strftime('%Y-%m-%d')} 9:10:00', '{start_date.strftime('%Y-%m-%d')} 10:46:00', '00:45'),")
    start_date += delta
'''
