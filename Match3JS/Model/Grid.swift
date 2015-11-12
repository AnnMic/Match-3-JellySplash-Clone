import Foundation


//A 2D grid that is used to hold the gems
struct Grid<T> {
    var nbrOfRows: Int
    var nbrOfColums: Int

    var grid: [T?]

    init(rows: Int, colums: Int) {
        nbrOfRows = rows
        nbrOfColums = colums

        grid = Array<T?>(count: nbrOfRows * nbrOfColums, repeatedValue: nil)
    }

    subscript(row: Int, column: Int) -> T? {
        get {
            assert(isIndexValid(row, column: column), "Index out of range")
            return grid[row * nbrOfColums + column]
        }
        set(newValue) {
            assert(isIndexValid(row, column: column), "Index out of range")

            grid[row * nbrOfColums + column] = newValue
        }
    }

    func isIndexValid(row: Int, column: Int) -> Bool {
        return row < nbrOfRows && row >= 0 && column < nbrOfColums && column >= 0
    }
}