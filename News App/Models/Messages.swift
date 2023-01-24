//
//  NSError+Extension.swift
//  News App
//
//  Created by Premier20 on 29/07/21.
//

import UIKit

enum MessageType: String {
    case profile
    case articles
    case noSavedArticles
    case savedArticles
    case completeAllFields
    case cancel
    case cancelButton
    case changePassword
    case newPassword
    case confirmNewPassword
    case differentPassword
    case invalidPassword
    case accessPassword
    case password
    case passwordAgain
    case forgotPassword
    case emailCode
    case email
    case emailIncorrectOrNotExist
    case emailField
    case invalidEmail
    case error
    case editPhoto
    case editProfile
    case firstName
    case lastName
    case ok
    case send
    case sendEmail
    case success
    case successfullyCreated
    case update
    case updateData
    case exit
    case wantToLeave
    case loginAgain
    case whatUGonnaDo
    case welcome
    case login
    case register
    case loginMessage
    case registerButton
    case somethingWasWrong
    case pleaseWait
    case takePicture
    case profilePicture
    case choosePhoto
    case photoMessage
    case changePhoto
    case changeProfile
    case changeProfileMessage
    case currentPassword
    case messageErrorPassword
    case successfullyPassword

    var message: String {
        switch self {
        case .successfullyPassword:
            return NSLocalizedString("Senha alterada com sucesso", comment: "")
        case .messageErrorPassword:
            return NSLocalizedString("Não foi possivel alterar sua senha", comment: "")
        case .currentPassword:
            return NSLocalizedString("Senha atual", comment: "")
        case .changeProfileMessage:
            return NSLocalizedString("O seu perfil foi atualizado com sucesso!", comment: "")
        case .changeProfile:
            return NSLocalizedString("Pefil atualizado", comment: "")
        case .changePhoto:
            return NSLocalizedString("Imagem alterada com sucesso", comment: "")
        case .photoMessage:
            return NSLocalizedString("Como você gostaria de selecionar uma foto?", comment: "")
        case .profilePicture:
            return NSLocalizedString("Foto de Perfil", comment: "")
        case .takePicture:
            return NSLocalizedString("Tirar Foto", comment: "")
        case .choosePhoto:
            return NSLocalizedString("Escolher da galeria", comment: "")
        case .pleaseWait:
            return NSLocalizedString("Por favor aguarde...", comment: "")
        case .articles:
            return NSLocalizedString("Artigos", comment: "")
        case .register:
            return NSLocalizedString("Cadastre-se", comment: "")
        case .login:
            return NSLocalizedString("ENTRAR", comment: "")
        case .forgotPassword:
            return NSLocalizedString("Esqueci minha senha", comment: "")
        case .loginMessage:
            return NSLocalizedString("Faça seu login no app!", comment: "")
        case .somethingWasWrong:
            return NSLocalizedString("Algo deu errado, tente novamente", comment: "")
        case .successfullyCreated:
            return NSLocalizedString("Conta criada com sucesso", comment: "")
        case .registerButton:
            return NSLocalizedString("CADASTRAR", comment: "")
        case .password:
            return NSLocalizedString("Senha", comment: "")
        case .passwordAgain:
            return NSLocalizedString("Senha novamente", comment: "")
        case .accessPassword:
            return NSLocalizedString("Senha de acesso", comment: "")
        case .welcome:
            return NSLocalizedString("Bem Vindo(a) \n Preencha seus dados para começar!", comment: "")
        case .profile:
            return NSLocalizedString("Perfil", comment: "")
        case .noSavedArticles:
            return NSLocalizedString("Você ainda não tem nenhum artigo salvo", comment: "")
        case .savedArticles:
            return NSLocalizedString("Artigos salvos", comment: "")
        case .completeAllFields:
            return NSLocalizedString("Por favor preencha todos os campos", comment: "")
        case .cancel:
            return NSLocalizedString("CANCELAR", comment: "")
        case .cancelButton:
            return NSLocalizedString("Cancelar", comment: "")
        case .changePassword:
            return NSLocalizedString("Alterar senha", comment: "")
        case .newPassword:
            return NSLocalizedString("Nova senha", comment: "")
        case .confirmNewPassword:
            return NSLocalizedString("Confirmar nova senha", comment: "")
        case .differentPassword:
            return NSLocalizedString("As senhas devem ser iguais", comment: "")
        case .invalidPassword:
            return NSLocalizedString("A senha não é válida", comment: "")
        case .emailCode:
            return NSLocalizedString("Enviaremos um código para o seu e-mail", comment: "")
        case .email:
            return NSLocalizedString("E-mail", comment: "")
        case .emailIncorrectOrNotExist:
            return NSLocalizedString("E-mail incorreto ou inexistente", comment: "")
        case .emailField:
            return NSLocalizedString("Por favor complete o campo de e-mail", comment: "")
        case .invalidEmail:
            return NSLocalizedString("O endereço de e-mail não é válido", comment: "")
        case .error:
            return NSLocalizedString("ERRO", comment: "")
        case .editPhoto:
            return NSLocalizedString(" Editar foto", comment: "")
        case .editProfile:
            return NSLocalizedString("Editar Perfil", comment: "")
        case .firstName:
            return NSLocalizedString("Nome", comment: "")
        case .lastName:
            return NSLocalizedString("Sobrenome", comment: "")
        case .ok:
            return NSLocalizedString("OK", comment: "")
        case .send:
            return NSLocalizedString("ENVIAR", comment: "")
        case .sendEmail:
            return NSLocalizedString("Enviada solicitação por e-mail", comment: "")
        case .success:
            return NSLocalizedString("Sucesso!", comment: "")
        case .update:
            return NSLocalizedString("ATUALIZAR", comment: "")
        case .updateData:
            return NSLocalizedString("Dados alterados com sucesso.", comment: "")
        case .exit:
            return NSLocalizedString("Sair", comment: "")
        case .wantToLeave:
            return NSLocalizedString("Deseja sair?", comment: "")
        case .loginAgain:
            return NSLocalizedString("Você deverá efetuar o login novamente", comment: "")
        case .whatUGonnaDo:
            return NSLocalizedString("O que deseja fazer?", comment: "")
        }
    }
}
