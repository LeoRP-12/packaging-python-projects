from lark import Lark, Transformer
from lark.exceptions import *


class MarkdownTreeToList(Transformer):
    '''
        Class to transform a tree object, output of lark librarie,
        into a list object with markdown parsed

     '''

    def document(self, s):
        return list(s)

    def header(self, content):
        (content,) = content
        return ['Header', content[:]]

    def paragraph(self, content):
        (content,) = content
        return ['Paragraph', content[:]]


class MarkdownParser():
    '''
        Parse markdown into python list
        example:
        markdown_parsed = MarkdownParser('path_to_file').parse()

     '''

    def __init__(self, file_path: str = ''):

        self.grammar = r"""
                ?start: document
                document: (header | paragraph)*
                header: /^(#{1,6})(\s).*/m
                paragraph: /.+?\n\n|.+?$/m
                %import common.WS
                %ignore WS
           """
        self.file_path = file_path
        self.parser = Lark(self.grammar, parser='lalr', transformer=MarkdownTreeToList())

        with open(file_path) as f:
            self.markdown = f.read()

    def parse(self) -> List:
        try:
            output = self.parser.parse(self.markdown)
            return output
        except (ParseError, UnexpectedInput, UnexpectedToken) as e:
            print('Markdown provided cannot be parsed into a list. Please use proper formatting.', e)
        except Exception as e:
            print('Exception occured: ', e)