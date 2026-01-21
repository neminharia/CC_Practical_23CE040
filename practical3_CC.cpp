#include <iostream>
#include <cstdio>
#include <string>
#include <vector>
#include <set>
#include <cctype>
#include <algorithm>

using namespace std;

const set<string> KEYWORDS = {
    "int", "float", "char", "return", "if", "else", "while", "for",
    "void", "main", "double", "long", "struct", "break", "continue"};

const set<string> OPERATORS = {
    "+", "-", "*", "/", "=", "==", "!=", "<", ">", "<=", ">=", "%", "."};

const set<char> PUNCTUATION = {
    ';', ',', '(', ')', '{', '}', '[', ']', '&'};

struct Token
{
    string type;
    string value;
};

vector<Token> tokenList;
vector<string> errorList;
set<string> symbolTable;

bool isKeyword(const string &str)
{
    return KEYWORDS.find(str) != KEYWORDS.end();
}

bool isOperator(const string &str)
{
    return OPERATORS.find(str) != OPERATORS.end();
}

bool isPunctuation(char ch)
{
    return PUNCTUATION.find(ch) != PUNCTUATION.end();
}

bool isInvalidLexeme(const string &str)
{
    if (str.empty())
        return false;
    if (isdigit(str[0]))
    {
        for (char c : str)
        {
            if (isalpha(c))
                return true;
        }
    }
    return false;
}
bool isConstant(const string &str)
{
    if (str.empty())
        return false;
    bool hasDecimal = false;
    for (int k = 0; k < str.length(); k++)
    {
        if (str[k] == '.')
        {
            if (hasDecimal)
                return false;
            hasDecimal = true;
        }
        else if (!isdigit(str[k]))
        {
            return false;
        }
    }
    return true;
}

string readFile(const char *filename)
{
    FILE *fp = fopen(filename, "r");
    if (!fp)
    {
        perror("Error opening file");
        exit(1);
    }
    fseek(fp, 0, SEEK_END);
    long length = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    string buffer;
    buffer.resize(length);
    fread(&buffer[0], 1, length, fp);

    fclose(fp);
    return buffer;
}

void lexicalAnalyzer(string sourceCode)
{
    int n = sourceCode.length();
    int lineNum = 1;
    int i = 0;

    while (i < n)
    {
        char ch = sourceCode[i];

        if (ch == '\n')
        {
            lineNum++;
            i++;
            continue;
        }

        if (isspace(ch))
        {
            i++;
            continue;
        }

        if (ch == '/' && i + 1 < n && sourceCode[i + 1] == '/')
        {
            while (i < n && sourceCode[i] != '\n')
                i++;
            continue;
        }
        if (ch == '/' && i + 1 < n && sourceCode[i + 1] == '*')
        {
            i += 2;
            while (i + 1 < n && !(sourceCode[i] == '*' && sourceCode[i + 1] == '/'))
            {
                if (sourceCode[i] == '\n')
                    lineNum++;
                i++;
            }
            i += 2;
            continue;
        }

        if (ch == '"')
        {
            string literal = "";
            literal += ch;
            i++;
            while (i < n && sourceCode[i] != '"')
            {
                if (sourceCode[i] == '\n')
                    lineNum++;
                literal += sourceCode[i];
                i++;
            }
            if (i < n)
            {
                literal += sourceCode[i];
                i++;
            }
            tokenList.push_back({"Constant", literal});
            continue;
        }

        bool startsWithDotDigit = (ch == '.' && i + 1 < n && isdigit(sourceCode[i + 1]));

        if (isdigit(ch) || startsWithDotDigit)
        {
            string numStr = "";
            if (startsWithDotDigit)
            {
                numStr += '.';
                i++;
            }
            while (i < n && (isdigit(sourceCode[i]) || sourceCode[i] == '.'))
            {
                if (sourceCode[i] == '.' && numStr.find('.') != string::npos)
                    break;
                if (isalpha(sourceCode[i]))
                {
                }
                numStr += sourceCode[i];
                i++;
            }
            while (i < n && isalpha(sourceCode[i]))
            {
                numStr += sourceCode[i];
                i++;
            }

            if (isInvalidLexeme(numStr))
            {
                errorList.push_back("Line " + to_string(lineNum) + " : " + numStr + " invalid lexeme");
            }
            else
            {
                tokenList.push_back({"Constant", numStr});
            }
            continue;
        }

        if (i + 1 < n)
        {
            string op2 = sourceCode.substr(i, 2);
            if (isOperator(op2))
            {
                tokenList.push_back({"Operator", op2});
                i += 2;
                continue;
            }
        }

        string op1(1, ch);
        if (isOperator(op1))
        {
            tokenList.push_back({"Operator", op1});
            i++;
            continue;
        }
        if (isPunctuation(ch))
        {
            tokenList.push_back({"Punctuation", op1});
            i++;
            continue;
        }

        if (isalpha(ch) || ch == '_')
        {
            string word = "";
            while (i < n && (isalnum(sourceCode[i]) || sourceCode[i] == '_'))
            {
                word += sourceCode[i];
                i++;
            }

            if (isKeyword(word))
            {
                tokenList.push_back({"Keyword", word});
            }
            else
            {
                tokenList.push_back({"Identifier", word});
                symbolTable.insert(word);
            }
            continue;
        }

        i++;
    }
}

int main()
{
    string filename = "input_prac3_cc.txt";

    cout << "Reading from " << filename << "..." << endl;
    string code = readFile(filename.c_str());

    lexicalAnalyzer(code);

    cout << "\n--- TOKENS ---" << endl;
    for (const auto &t : tokenList)
    {
        cout << t.type << ": " << t.value << endl;
    }

    cout << "\n--- LEXICAL ERRORS ---" << endl;
    if (errorList.empty())
    {
        cout << "None" << endl;
    }
    else
    {
        for (const auto &e : errorList)
            cout << e << endl;
    }

    cout << "\n--- SYMBOL TABLE ENTRIES ---" << endl;
    int idx = 1;
    for (const auto &s : symbolTable)
    {
        cout << idx++ << ") " << s << endl;
    }

    return 0;
}