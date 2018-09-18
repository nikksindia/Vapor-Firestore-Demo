import Vapor
struct Developer: Content {
    var name: String
    var favLanguage: String
    var age: Int
}
/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    func fernoGet(_ req:Request) throws -> Future<[Todo]>{
//        let httpClient = try Service.c.make(Client.self)
//        let config = try container.make(FernoConfig.self)
//        let client =  FernoClient(client: httpClient, basePath: config.basePath, email: config.email, privateKey: config.privateKey)
        let clt = try req.client()
        let fernoClt = FernoClient(client: clt, basePath: Constants.DATABSE_PATH_URL, email: Constants.SERVICE_ACCOUNT_EMAIL, privateKey: Constants.SERVICE_ACCOUNT_SECRET)
        return Todo.query(on: req).all()
    }
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]>{
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<FernoChild> {
        let clt = try req.client()
        let fernoClt = FernoClient(client: clt, basePath: Constants.DATABSE_PATH_URL, email: Constants.SERVICE_ACCOUNT_EMAIL, privateKey: Constants.SERVICE_ACCOUNT_SECRET)
        let newDeveloper = Developer(name: "Elon", favLanguage: "Python", age: 46)
        let newDeveloperKey: Future<FernoChild> = try fernoClt.ferno.create(req: req, appendedPath: ["developers"], body: newDeveloper)
        return newDeveloperKey
//        return try req.content.decode(Todo.self).flatMap { todo in
//            return todo.save(on: req)
//        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }
}
