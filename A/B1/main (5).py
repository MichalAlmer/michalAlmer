import os
from collections import defaultdict

# פונקציה 1: חלוקת הקובץ הגדול לקבצים קטנים יותר
def divide_log_file(input_path, output_folder, lines_per_chunk):
    os.makedirs(output_folder, exist_ok=True)
    chunks = []
    current_chunk = []
    file_index = 0

    with open(input_path, 'r') as infile:
        for line_number, line in enumerate(infile, 1):
            current_chunk.append(line)

            if line_number % lines_per_chunk == 0:
                part_path = os.path.join(output_folder, f"log_part_{file_index}.txt")
                with open(part_path, 'w') as part_file:
                    part_file.writelines(current_chunk)
                chunks.append(part_path)
                current_chunk = []
                file_index += 1

        # שמירה של החלק האחרון אם נשארו שורות
        if current_chunk:
            part_path = os.path.join(output_folder, f"log_part_{file_index}.txt")
            with open(part_path, 'w') as part_file:
                part_file.writelines(current_chunk)
            chunks.append(part_path)

    return chunks


# פונקציה 2: ספירת קודי שגיאה מתוך קובץ בודד
def count_errors_from_file(file_path):
    counts = defaultdict(int)
    skipped_lines = 0

    with open(file_path, 'r') as f:
        for line in f:
            code = extract_error_code(line)
            if code:
                counts[code] += 1
            else:
                skipped_lines += 1

    return counts, skipped_lines


# פונקציה 3: מיזוג ספירות בין מילונים
def combine_dictionaries(global_count, local_count):
    for key, value in local_count.items():
        global_count[key] += value


# פונקציה 4: חילוץ קוד שגיאה מתוך שורת טקסט
def extract_error_code(line):
    keyword = "Error: "
    start = line.find(keyword)

    if start == -1:
        return None

    start += len(keyword)
    end = line.find(' ', start)
    if end == -1:
        end = len(line)

    return line[start:end].strip()


# ----------------------------
# פונקציה 5: מציאת N הקודים השכיחים ביותר
# ----------------------------
def top_n_errors(error_dict, n):
    return sorted(error_dict.items(), key=lambda x: x[1], reverse=True)[:n]


# פונקציה ראשית: התהליך המלא
def process_log_file():
    input_path = r'C:\Users\user1\Desktop\Hadasim\part\logs1.txt'
    output_folder = r'C:\Users\user1\Desktop\log_parts\\'
    lines_per_file = 100000
    n = int(input("כמה קודי שגיאה להציג? "))

    print("\n🔄 מפצלת את הקובץ הגדול...")
    chunk_files = divide_log_file(input_path, output_folder, lines_per_file)

    print("📊 מנתחת קבצים...")
    overall_counts = defaultdict(int)
    total_skipped = 0

    for chunk in chunk_files:
        local_counts, skipped = count_errors_from_file(chunk)
        combine_dictionaries(overall_counts, local_counts)
        total_skipped += skipped

    print("\n🔥 הקודים השכיחים ביותר:")
    for code, count in top_n_errors(overall_counts, n):
        print(f"{code}: {count} מופעים")

    print(f"\nℹ️ שורות שלא זוהה בהן קוד שגיאה: {total_skipped}")


# ניתוח סיבוכיות
# זמן:
#   קריאה: O(M) – M = מספר שורות
#   מיון: O(E log E) – E = מספר קודי שגיאה שונים
# מקום:
#   אחסון מילון קודים: O(E)
#   אחסון זמני של חלקי קבצים – רק אם נדרש

# הפעלת התוכנית
if __name__ == "__main__":
    process_log_file()
