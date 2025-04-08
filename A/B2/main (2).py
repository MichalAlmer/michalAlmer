
import pandas as pd
import os

# קריאת קובץ וסינון נתונים
def load_and_clean(file_path):
    df = pd.read_csv(file_path, parse_dates=['timestamp'], dayfirst=True)
    df['value'] = pd.to_numeric(df['value'], errors='coerce')
    df = df.dropna(subset=['timestamp', 'value'])
    return df

# חלוקה לפי יום
def split_by_day(df, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    df['date'] = df['timestamp'].dt.date
    for date, group in df.groupby('date'):
        path = os.path.join(output_dir, f"time_series_{date}.csv")
        group.drop(columns='date').to_csv(path, index=False)

# חישוב ממוצעים שעתיים מכל קובץ יומי
def compute_hourly_averages(folder_path):
    all_results = []
    for file in os.listdir(folder_path):
        if file.endswith(".csv"):
            df = pd.read_csv(os.path.join(folder_path, file), parse_dates=['timestamp'])
            df['hour'] = df['timestamp'].dt.floor('H')
            hourly_avg = df.groupby('hour')['value'].mean().reset_index()
            all_results.append(hourly_avg)
    return pd.concat(all_results, ignore_index=True)

# הרצה
def main():
    input_file = r'C:\Users\user1\Desktop\Hadasim\part1\time_series.csv'
    temp_dir = r'C:\Users\user1\Desktop\Hadasim\part1\daily_parts\'
    output_file = r'C:\Users\user1\Desktop\Hadasim\part1\hourly_means_by_day.xlsx'

    df = load_and_clean(input_file)
    split_by_day(df, temp_dir)
    result = compute_hourly_averages(temp_dir)
    result.to_excel(output_file, index=False)
    print("✔ הקובץ נשמר:", output_file)

if __name__ == '__main__':
    main()
